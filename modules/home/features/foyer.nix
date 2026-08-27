{ inputs, ... }:
{
  flake.homeModules.foyer =
    { pkgs, lib, ... }:
    let
      resolveSession = ''
        resolve_session() {
          if [ -n "''${ZELLIJ_SESSION_NAME:-}" ]; then
            printf '%s\n' "$ZELLIJ_SESSION_NAME"
            return 0
          fi
          local live
          live="$(zellij list-sessions --no-formatting 2>/dev/null \
            | grep -v 'EXITED' \
            | sed -E 's/ .*$//')"
          local count
          count="$(printf '%s' "$live" | grep -c . || true)"
          if [ "$count" = "1" ]; then
            printf '%s\n' "$live"
            return 0
          fi
          echo "foyer/zellij hook: cannot resolve a single live zellij session (found $count); set ZELLIJ_SESSION_NAME" >&2
          return 1
        }
      '';

      tabName = ''
        tab_name() {
          local base="$1"
          case "$base" in
            *-*) printf '%s | %s\n' "''${base%%-*}" "''${base#*-}" ;;
            *)   printf '%s\n' "$base" ;;
          esac
        }
      '';

      createHook = pkgs.writeShellApplication {
        name = "foyer-zellij-create";
        runtimeInputs = [ pkgs.zellij ];
        text = ''
          ${resolveSession}
          ${tabName}

          root="''${JJ_WORKSPACE_ROOT:-$PWD}"
          tab="$(tab_name "$(basename "$root")")"

          session="$(resolve_session)" || exit 0

          zellij --session "$session" action new-tab \
            --cwd "$root" \
            --name "$tab" \
            -- nvim
        '';
      };

      removeHook = pkgs.writeShellApplication {
        name = "foyer-zellij-remove";
        runtimeInputs = [ pkgs.zellij ];
        text = ''
          ${resolveSession}
          ${tabName}

          root="''${JJ_WORKSPACE_ROOT:-$PWD}"
          tab="$(tab_name "$(basename "$root")")"

          session="$(resolve_session)" || exit 0

          # Only touch a tab that actually carries this workspace's name, so a
          # stale or hand-renamed layout is never closed by mistake.
          if zellij --session "$session" action query-tab-names 2>/dev/null \
            | grep -Fxq "$tab"; then
            zellij --session "$session" action go-to-tab-name "$tab"
            zellij --session "$session" action close-tab
          else
            echo "foyer/zellij hook: no tab named '$tab' in session '$session'; nothing to close" >&2
          fi
        '';
      };
    in
    {
      imports = [ inputs.foyer.homeModules.foyer ];
      programs.foyer = {
        enable = true;
        hooks = {
          create = [
            {
              name = "zellij-tab";
              source = lib.getExe createHook;
            }
          ];
          remove = [
            {
              name = "zellij-tab";
              source = lib.getExe removeHook;
            }
          ];
        };
      };
    };
}
