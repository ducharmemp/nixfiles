{ inputs, self, ... }:
{
  flake.homeModules.gtreesitter =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins.treesitter = {
          enable = true;
          settings.highlight.enable = true;
          settings.incremental_selection.enable = true;
        };
        plugins.treesitter-textobjects = {
          enable = true;
          settings = {
            lsp_interop.enable = true;
            move.enable = true;
            select.enable = true;
            swap.enable = true;
          };
        };
      };
    };
}
