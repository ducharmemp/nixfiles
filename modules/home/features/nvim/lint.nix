{ inputs, self, ... }:
{
  flake.homeModules.nvim-lint =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins.lint.enable = true;
      };
    };
}
