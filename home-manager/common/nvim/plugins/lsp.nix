{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [ inputs.expert.packages.${pkgs.system}.default ];
  programs.nixvim = {
    plugins.lspconfig.enable = true;
    lsp = {
      servers = {
        tailwindcss.enable = true;
        yamlls.enable = true;
        html.enable = true;
        ts_ls.enable = true;
        svelte.enable = true;
        nextls.enable = true;
        nixd.enable = true;
      };
    };
    extraConfigLua = ''
      vim.lsp.config('expert', {
        cmd = { '${inputs.expert.packages.${pkgs.system}.default}/bin/expert' },
        root_markers = { 'mix.exs', '.git' },
        filetypes = { 'elixir', 'eelixir', 'heex' },
      })
      vim.lsp.enable('expert')
    '';
  };
}
