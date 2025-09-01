{ ... } : {
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      settings.highlight.enable = true;
      settings.incremental_selection.enable = true;
    };
    plugins.treesitter-textobjects = {
      enable = true;
      lspInterop.enable = true;
      move.enable = true;
      select.enable = true;
      swap.enable = true;
    };
  };
}
