{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  xdg = {
    configFile."cosmic-theme" = {
      source = builtins.fetchGit {
        url = "https://github.com/catppuccin/cosmic-desktop.git";
        rev = "fea2e508f3ab53cf5762a7610f4b6cc3a8f42a95";
      };
    };
  };
}
