{ inputs, self, ... }:
{
  flake.homeModules.gts-autotag =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins.ts-autotag.enable = true;
      };
    };
}
