{ inputs, self, ... }:
{
  flake.homeModules.aerospace =
    { pkgs, ... }:
    {
      programs.aerospace = {
        enable = true;
        launchd.enable = true;
        userSettings = {
          start-at-login = true;
          automatically-unhide-macos-hidden-apps = true;
          after-startup-command = [
            "exec-and-forget sketchybar"
          ];
          gaps.inner.horizontal = 8;
          gaps.inner.vertical = 8;
          gaps.outer.left = 8;
          gaps.outer.right = 8;
          gaps.outer.bottom = 8;
          gaps.outer.top = 48;
          exec-on-workspace-change = [
            "/usr/bin/env"
            "sketchybar"
            "--trigger"
            "aerospace_workspace_change"
          ];
        };
      };
    };
}
