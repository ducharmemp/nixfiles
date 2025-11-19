{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.wezterm = {
    enable = true;
    # package = inputs.wezterm.packages.${pkgs.system}.default;
  };

  xdg = {
    configFile."wezterm" = {
      source = ./wezterm;
      recursive = true;
    };
  };
}
