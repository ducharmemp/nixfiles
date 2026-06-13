_:
{
  flake.homeModules.nvim-ts-autotag =
    _:
    {
      programs.nixvim = {
        plugins.ts-autotag.enable = true;
      };
    };
}
