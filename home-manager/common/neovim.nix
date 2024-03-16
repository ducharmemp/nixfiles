{pkgs, ...} : {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withRuby = false;

    extraLuaConfig = builtins.readFile ./kickstart.lua;
  };
}
