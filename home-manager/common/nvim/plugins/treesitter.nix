{ ... } : {
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      settings.highlight.enable = true;
      settings.incremental_selection.enable = true;
    };
  };
}
