{ inputs, self, ... }:
{
  flake.homeModules.zellij =
    { pkgs, ... }:
    {
      programs.zellij = {
        enable = true;
        settings = {
          theme = "catppuccin-macchiato";
        };
      };
    };
}
