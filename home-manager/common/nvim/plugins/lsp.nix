{ ... } : {
  programs.nixvim = {
    plugins.lspconfig.enable = true;
    lsp = {
      servers = {
        tailwindcss.enable = true;
        yamlls.enable = true;
        html.enable = true;
        ts_ls.enable = true;
        ruby_lsp = {
          enable = true;
          package = null;
          settings = {
            cmd = [ "gem" "exec" "ruby-lsp" ];
            init_options = {
              formatter = "rubocop";
              linters = [ "rubocop" ];
              addonSettings.__raw = ''{
                ["Ruby LSP Rails"] = {
                  enablePendingMigrationsPrompt = false
                }
              }'';
            };
          };
        };
      };
    };
  };
}
