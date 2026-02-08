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
        };
      };
    };
}
