{ lib, pkgs, ... }: {
  xdg = {
    configFile."wezterm" = {
      source = ./wezterm;
      recursive = true;
    };
  };
}
