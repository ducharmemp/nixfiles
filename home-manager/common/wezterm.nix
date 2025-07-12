{ lib, pkgs, ... }: {
  programs.wezterm = {
    enable = true;
    package = pkgs.unstable.wezterm;
  };

  xdg = {
    configFile."wezterm" = {
      source = ./wezterm;
      recursive = true;
    };
  };
}
