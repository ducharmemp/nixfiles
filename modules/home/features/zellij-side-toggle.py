import json
import os
import re
import subprocess
import sys

ZELLIJ, SIDE = sys.argv[1], sys.argv[2]
NVIM = sys.argv[3] if len(sys.argv) > 3 else "nvim"
INBOX = 'pane size=48 name="inbox" { plugin location="session-manager" { role "manager_focused"; }; }'
STRAPS_NAME = "straps"


def action(*args):
    return subprocess.run([ZELLIJ, "action", *args], capture_output=True, text=True, check=True).stdout


def kdl_string(value):
    return json.dumps(value)


def depth_delta(line):
    depth, quoted, escaped = 0, False, False
    for ch in line:
        if escaped:
            escaped = False
        elif ch == "\\":
            escaped = True
        elif ch == '"':
            quoted = not quoted
        elif not quoted and ch == "{":
            depth += 1
        elif not quoted and ch == "}":
            depth -= 1
    return depth


def blocks(lines):
    out, cur, depth = [], [], 0
    for line in lines:
        cur.append(line)
        depth += depth_delta(line)
        if depth == 0:
            out.append(cur)
            cur = []
    return out


def is_pane(block):
    return re.match(r"\s*pane\b", block[0]) is not None


def command_text(block):
    command = re.search(r'command="([^"]*)"', block[0])
    if not command:
        return None
    args = next((line for line in block[1:] if re.match(r"\s*args ", line)), "")
    return " ".join([command.group(1)] + re.findall(r'"([^"]*)"', args))


def straps_leaf(block, root, launched):
    entry = next((e for e in launched if e.endswith(" -c Straps")), None)
    if entry is None:
        return None
    launched.remove(entry)
    cwd = re.search(r'cwd="([^"]*)"', block[0])
    size = re.search(r'size=("[^"]*"|\d+)', block[0])
    head = block[0]
    indent = head[: len(head) - len(head.lstrip())]
    return [indent + "pane%s name=%s command=%s%s close_on_exit=true { args %s %s; }" % (
        " size=" + size.group(1) if size else "", kdl_string(STRAPS_NAME), kdl_string(entry[: -len(" -c Straps")]),
        " cwd=" + kdl_string(os.path.join(root, cwd.group(1))) if cwd else "", kdl_string("-c"), kdl_string("Straps"))]


def leaf(block, root, launched):
    if 'name="%s"' % STRAPS_NAME in block[0]:
        kept = straps_leaf(block, root, launched)
        if kept is not None:
            return kept
    text = command_text(block)
    if text is not None and text in launched:
        launched.remove(text)
        head = re.sub(r'cwd="([^"]*)"', lambda m: 'cwd="%s"' % os.path.join(root, m.group(1)), block[0])
        return [head] + [line for line in block[1:] if line.strip() != "start_suspended true"]
    head = block[0]
    indent = head[: len(head) - len(head.lstrip())]
    return [indent + re.sub(r'\s(command|cwd|name)="[^"]*"', "", head.strip().rstrip("{").strip())]


def rebuild(block, root, launched):
    children = blocks(block[1:-1]) if block[0].rstrip().endswith("{") else []
    if any(child[0].lstrip().startswith("plugin ") for child in children):
        return block
    if not any(is_pane(child) for child in children):
        return leaf(block, root, launched)
    out = [block[0]]
    for child in children:
        out.extend(rebuild(child, root, launched) if is_pane(child) else child)
    out.append(block[-1])
    return out


def add_side(active, panes, left, right):
    top = blocks(action("dump-layout").splitlines()[1:-1])
    root = next((m.group(1) for b in top if (m := re.match(r'\s*cwd "(.*)"', b[0]))), "/")
    tab = [b for b in top if b[0].lstrip().startswith("tab ")][active["position"]]
    launched = [p["terminal_command"] for p in panes if not p["is_plugin"] and p.get("terminal_command")]
    head, content, tail = [], [], []
    for block in blocks(tab[1:-1]):
        if "zellij:bars" in "".join(block):
            (tail if content else head).append(block)
        elif block[0].lstrip().startswith("floating_panes"):
            tail.append(block)
        else:
            content.append(rebuild(block, root, launched))
    layout = (
        ["layout {", "tab {"]
        + [line for b in head for line in b]
        + ['pane split_direction="vertical" {'] + left + ["pane {"]
        + [line for b in content for line in b]
        + ["}"] + right + ["}"]
        + [line for b in tail for line in b]
        + ["}", "}"]
    )
    known = {p["id"] for p in panes if not p["is_plugin"]}
    action("override-layout", "--layout-string", "\n".join(layout),
           "--retain-existing-terminal-panes", "--retain-existing-plugin-panes", "--apply-only-to-active-tab")
    added = [p for p in json.loads(action("list-panes", "-j"))
             if p["tab_id"] == active["tab_id"] and not p["is_plugin"] and p["id"] not in known]
    for p in added:
        if p["title"] == STRAPS_NAME:
            action("focus-pane-id", "terminal_%d" % p["id"])
        else:
            action("close-pane", "-p", "terminal_%d" % p["id"])


def focused_cwd(panes):
    focused = [p for p in panes if p["is_focused"] and not p["is_plugin"]]
    cwd = focused[0].get("pane_cwd") if focused else None
    return cwd or os.getcwd()


def straps_slot(cwd):
    return ["pane size=%s name=%s command=%s cwd=%s close_on_exit=true focus=true { args %s %s; }" % (
        kdl_string("20%"), kdl_string(STRAPS_NAME), kdl_string(NVIM), kdl_string(cwd), kdl_string("-c"),
        kdl_string("Straps"))]


def main():
    active = next(t for t in json.loads(action("list-tabs", "-j")) if t.get("active"))
    panes = [p for p in json.loads(action("list-panes", "-j")) if p["tab_id"] == active["tab_id"]]
    if SIDE == "inbox":
        existing = [p for p in panes if p.get("plugin_url") == "session-manager" and not p["is_floating"]]
        if not existing:
            add_side(active, panes, [INBOX], [])
        for p in existing:
            action("close-pane", "-p", "plugin_%d" % p["id"])
    elif SIDE == "straps":
        existing = [p for p in panes if not p["is_plugin"] and p["title"] == STRAPS_NAME]
        if not existing:
            add_side(active, panes, [], straps_slot(focused_cwd(panes)))
        for p in existing:
            action("close-pane", "-p", "terminal_%d" % p["id"])
    else:
        sys.exit("unknown side: %s" % SIDE)


main()
