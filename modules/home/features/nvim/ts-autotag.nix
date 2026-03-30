{ inputs, self, ... }:
{
  flake.homeModules.nvim-ts-autotag =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins.ts-autotag.enable = true;
      };
    };
}
