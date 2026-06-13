_:
{
  flake.homeModules.nvim-lint =
    _:
    {
      programs.nixvim = {
        plugins.lint.enable = true;
      };
    };
}
