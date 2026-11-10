_:
{
  flake.homeModules.zellij =
    { pkgs, lib, config, ... }:
    let
      sideToggle = pkgs.writers.writePython3Bin "zellij-side-toggle" { doCheck = false; } (
        builtins.readFile ./zellij-side-toggle.py
      );
      toggle = key: args: {
        _args = [ key ];
        Run = {
          _args = [
            (lib.getExe sideToggle)
            (lib.getExe config.programs.zellij.package)
          ]
          ++ args;
          background = true;
        };
      };
    in
    {
      programs.zellij = {
        enable = true;
        settings = {
          show_startup_tips = false;
          show_release_notes = false;
          ui.pane_frames = {
            rounded_corners = true;
            hide_session_name = true;
          };
          attention = {
            startup_card = "never";
            tray_badge_colors = {
              needs_you = "#f5a97f";
              failed = "#ed8796";
              done = "#a6da95";
              working = "#8aadf4";
              quiet = "#6e738d";
              new_output = "#8bd5ca";
            };
          };
          keybinds.normal._children = [
            { bind = toggle "Alt a" [ "inbox" ]; }
            {
              bind = toggle "Alt s" [
                "straps"
                "${config.programs.nixvim.build.package}/bin/nvim"
              ];
            }
          ];
        };
      };
    };
}
