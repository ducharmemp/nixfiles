{ inputs, self, ... }:
{
  flake.homeModules.nvim-flash =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins.flash = {
          enable = true;
        };
      };
    };
}
