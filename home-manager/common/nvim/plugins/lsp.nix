{ ... } : {
  programs.nixvim = {
    plugins.lsp = {
      enable = true; 
      servers = {
        ruby_lsp.enable = true;
      };
    };
  };
}
