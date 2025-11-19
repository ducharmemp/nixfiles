{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withRuby = false;
    package = pkgs.neovim;
  };

  xdg = {
    configFile."nvim" = {
      source = ./neovim;
      recursive = true;
    };
  };
}
