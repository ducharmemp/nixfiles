{pkgs, ...}: {
    programs.fish = {
        enable = true;
        shellInit = ''
          set fish_greeting
          test -O ~/.aliases && source ~/.aliases
          wezterm shell-completion --shell fish > $HOME/.config/fish/completions/wezterm.fish
          set -g fish_key_bindings fish_vi_key_bindings
        '';
        plugins = [
            { name = "fzf-fish"; inherit (pkgs.fishPlugins.fzf-fish) src; }
            { name = "tide"; inherit (pkgs.fishPlugins.tide) src; }
        ];
  };
}
