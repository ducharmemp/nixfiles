{ inputs, self, ... }:
{
  flake.homeModules.wezterm =
    { pkgs, ... }:
    {
      programs.wezterm = {
        enable = true;
        package = inputs.wezterm.packages.${pkgs.system}.default;
      };

      xdg = {
        configFile."wezterm" = {
          source = ./homeModules/wezterm;
          recursive = true;
        };
      };
    };
}
