{pkgs, ...} : {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = builtins.readFile ./kickstart.lua;

    plugins = with pkgs; [
        vimPlugins.nvim-cmp
        vimPlugins.telescope-nvim
        vimPlugins.nvim-treesitter.withAllGrammars
        vimPlugins.nvim-colorizer-lua
        vimPlugins.which-key-nvim
        vimPlugins.nvim-lspconfig
        vimPlugins.nordic-nvim
    ];
  };
}
