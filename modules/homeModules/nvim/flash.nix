{ inputs, self, ... }:
{
  flake.homeModules.gflash =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins.flash = {
          enable = true;
        };
      };
    };
}
