_:
{
  flake.homeModules.nvim-flash =
    _:
    {
      programs.nixvim = {
        plugins.flash = {
          enable = true;
        };
      };
    };
}
