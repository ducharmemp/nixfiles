{ inputs, ... }:
{
  flake.homeModules.foyer =
    { pkgs, lib, config, ... }:
    let
      nvimBin = "${config.programs.nixvim.build.package}/bin/nvim";
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

      sandboxProfile = pkgs.writeText "foyer-nvim.sb" ''
        (version 1)
        (deny default)
        (allow process-exec process-fork)
        (allow sysctl-read mach-lookup signal)
        (allow file-read-metadata)

        (allow file-read* (literal "/"))
        (allow file-read*
          (subpath "/nix/store")
          (subpath "/nix/var")
          (subpath "/usr/lib")
          (subpath "/usr/share")
          (subpath "/System")
          (subpath "/Library")
          (subpath "/etc")
          (subpath "/private/etc")
          (subpath "/dev")
          (subpath "/private/var/db")
          (subpath "/private/var/select"))

        (allow file-read* (subpath (param "WS")))
        (allow file-read* (subpath (param "MAIN")))
        (allow file-read* (subpath (param "TMP")))
        (allow file-read*
          (subpath (string-append (param "HOME") "/.config"))
          (subpath (string-append (param "HOME") "/.ssh"))
          (subpath (string-append (param "HOME") "/.local/share/nvim"))
          (subpath (string-append (param "HOME") "/.local/state/nvim"))
          (subpath (string-append (param "HOME") "/.local/state/nix"))
          (subpath (string-append (param "HOME") "/.cache/nvim")))

        (allow file-write* (subpath (param "WS")))
        (allow file-write* (subpath (string-append (param "MAIN") "/.jj")))
        (allow file-write* (subpath (string-append (param "MAIN") "/.git")))
        (allow file-write* (subpath (param "TMP")))
        (allow file-write*
          (subpath (string-append (param "HOME") "/.local/share/nvim"))
          (subpath (string-append (param "HOME") "/.local/state/nvim"))
          (subpath (string-append (param "HOME") "/.cache/nvim")))

        (allow file-write-data
          (literal "/dev/null")
          (literal "/dev/zero")
          (literal "/dev/random")
          (literal "/dev/urandom")
          (literal "/dev/dtracehelper"))
        (allow file-ioctl (literal "/dev/dtracehelper"))

        (allow pseudo-tty)
        (allow file-write* file-ioctl
          (literal "/dev/ptmx")
          (literal "/dev/tty")
          (regex #"^/dev/ttys[0-9]+$"))

        (allow network-outbound network-inbound system-socket)
      '';

      resolveMain = ''
        resolve_main() {
          local ws="$1" ptr repo
          if [ ! -f "$ws/.jj/repo" ]; then
            printf '%s\n' "$ws"
            return 0
          fi
          ptr="$(cat "$ws/.jj/repo")"
          case "$ptr" in
            /*) repo="$ptr" ;;
            *)  repo="$(cd "$ws/.jj/$(dirname "$ptr")" && pwd -P)/$(basename "$ptr")" ;;
          esac
          (cd "$repo/../.." && pwd -P)
        }
      '';

      sandboxedNvim = pkgs.writeShellApplication {
        name = "foyer-nvim";
        text =
          ''
            ${resolveMain}

            ws="$(cd "''${JJ_WORKSPACE_ROOT:-$PWD}" && pwd -P)"
            main="$(resolve_main "$ws")"
            tmp="$(cd "''${TMPDIR:-/tmp}" && pwd -P)"
            home="$(cd "$HOME" && pwd -P)"
          ''
          + lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
            exec /usr/bin/sandbox-exec \
              -D WS="$ws" \
              -D MAIN="$main" \
              -D HOME="$home" \
              -D TMP="$tmp" \
              -f ${sandboxProfile} \
              ${nvimBin} "$@"
          ''
          + lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
            runtime="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

            exec ${lib.getExe pkgs.bubblewrap} \
              --ro-bind /nix /nix \
              --ro-bind /etc /etc \
              --ro-bind-try /usr /usr \
              --ro-bind-try /bin /bin \
              --ro-bind-try /sbin /sbin \
              --ro-bind-try /lib /lib \
              --ro-bind-try /lib64 /lib64 \
              --ro-bind-try /run /run \
              --ro-bind-try /sys /sys \
              --dev-bind /dev /dev \
              --proc /proc \
              --tmpfs "$home" \
              --ro-bind-try "$home/.config" "$home/.config" \
              --ro-bind-try "$home/.ssh" "$home/.ssh" \
              --ro-bind-try "$home/.local/state/nix" "$home/.local/state/nix" \
              --bind-try "$home/.local/share/nvim" "$home/.local/share/nvim" \
              --bind-try "$home/.local/state/nvim" "$home/.local/state/nvim" \
              --bind-try "$home/.cache/nvim" "$home/.cache/nvim" \
              --bind-try "$runtime" "$runtime" \
              --bind "$tmp" "$tmp" \
              --ro-bind "$main" "$main" \
              --bind "$main/.jj" "$main/.jj" \
              --bind-try "$main/.git" "$main/.git" \
              --bind "$ws" "$ws" \
              --die-with-parent \
              --chdir "$ws" \
              ${nvimBin} "$@"
          '';
      };

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
            -- ${lib.getExe sandboxedNvim}
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
