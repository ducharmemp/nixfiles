_:
{
  flake.homeModules.rift =
    { pkgs, ... }:
    let
      # rift config is plain TOML; build it from a Nix attrset so it stays
      # nix-native and reviewable. rift hot-reloads it (settings.hot_reload).
      tomlFormat = pkgs.formats.toml { };

      config = {
        settings = {
          animate = false;
          animation_duration = 0.3;
          animation_fps = 100.0;

          focus_follows_mouse = true;
          mouse_follows_focus = true;
          mouse_hides_on_focus = true;

          auto_focus_blacklist = [ ];

          # Bridge rift's workspace_changed event to sketchybar. Mirrors the
          # subscription that items/spaces.lua listens for (rift_workspace_changed,
          # RIFT_WORKSPACE_ID is 0-based). Centralised here so it is (re)installed
          # whenever rift starts, not only when sketchybar loads.
          # run_on_start runs each command directly (no shell, no user PATH), so
          # both binaries are referenced by absolute store path.
          run_on_start = [
            "${pkgs.rift}/bin/rift-cli subscribe cli --event workspace_changed --command ${pkgs.sketchybar}/bin/sketchybar --args --trigger --args rift_workspace_changed"
          ];

          hot_reload = true;

          layout = {
            mode = "traditional";
            window_insertion_point = "next_to_selection";
            traditional.equalize_nodes = true;
            gaps = {
              outer = {
                # Leave room at the top for the sketchybar (bar height ~25px
                # plus padding) so tiled windows do not sit under it.
                top = 40;
                left = 0;
                bottom = 0;
                right = 0;
              };
              inner = {
                horizontal = 0;
                vertical = 0;
              };
            };
          };
        };

        virtual_workspaces = {
          enabled = true;
          default_workspace_count = 4;
          auto_assign_windows = true;
          preserve_focus_per_workspace = true;
          workspace_auto_back_and_forth = false;
          prevent_wrapping = false;
          reapply_app_rules_on_title_change = false;
          workspace_rules = [ ];
          app_rules = [ ];
        };

        modifier_combinations.comb1 = "Alt + Shift";

        # rift's default keybindings (4 workspaces).
        keys = {
          "Alt + Z" = "toggle_space_activated";

          "Alt + H" = {
            move_focus = "left";
          };
          "Alt + J" = {
            move_focus = "down";
          };
          "Alt + K" = {
            move_focus = "up";
          };
          "Alt + L" = {
            move_focus = "right";
          };

          "comb1 + H" = {
            move_node = "left";
          };
          "comb1 + J" = {
            move_node = "down";
          };
          "comb1 + K" = {
            move_node = "up";
          };
          "comb1 + L" = {
            move_node = "right";
          };

          "Alt + 0" = {
            switch_to_workspace = 0;
          };
          "Alt + 1" = {
            switch_to_workspace = 1;
          };
          "Alt + 2" = {
            switch_to_workspace = 2;
          };
          "Alt + 3" = {
            switch_to_workspace = 3;
          };

          "comb1 + 0" = {
            move_window_to_workspace = 0;
          };
          "comb1 + 1" = {
            move_window_to_workspace = 1;
          };
          "comb1 + 2" = {
            move_window_to_workspace = 2;
          };
          "comb1 + 3" = {
            move_window_to_workspace = 3;
          };

          "Alt + Tab" = "switch_to_last_workspace";

          "Alt + Shift + Left" = {
            join_window = "left";
          };
          "Alt + Shift + Right" = {
            join_window = "right";
          };
          "Alt + Shift + Up" = {
            join_window = "up";
          };
          "Alt + Shift + Down" = {
            join_window = "down";
          };
          "Alt + Comma" = "toggle_stack";
          "Alt + Slash" = "toggle_orientation";
          "Alt + Ctrl + E" = "unjoin_windows";

          "Alt + Shift + Space" = "toggle_window_floating";
          "Alt + F" = "toggle_fullscreen";
          "Alt + Shift + F" = "toggle_fullscreen_within_gaps";
          "comb1 + Ctrl + Space" = "toggle_focus_floating";

          "Alt + Shift + Equal" = "resize_window_grow";
          "Alt + Shift + Minus" = "resize_window_shrink";

          "Alt + Enter" = {
            "exec" = [
              "/bin/bash"
              "-c"
              "open -a \"/System/Applications/Utilities/Terminal.app\""
            ];
          };

          "Alt + Shift + D" = "debug";

          # which-key style helper: pop the sketchybar keybindings panel.
          # rift's exec runs directly (no shell/PATH), so use absolute paths.
          "Alt + Ctrl + K" = {
            "exec" = [
              "${pkgs.sketchybar}/bin/sketchybar"
              "--trigger"
              "keybindings_toggle"
            ];
          };
        };
      };
    in
    {
      xdg.configFile."rift/config.toml".source = tomlFormat.generate "rift-config.toml" config;
    };
}
