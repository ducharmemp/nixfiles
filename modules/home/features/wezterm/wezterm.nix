{ inputs, self, ... }:
{
  flake.homeModules.wezterm =
    { pkgs, ... }:
    {
      programs.wezterm = {
        enable = true;
        package = inputs.wezterm.packages.${pkgs.system}.default;
        extraConfig = builtins.readFile ./wezterm.lua;
      };
    };
}
