{pkgs, ...}: {
    programs.fish = {
        enable = true;
        shellInit = ''
          set fish_greeting
          for p in (string split " " $NIX_PROFILES); fish_add_path --prepend --move $p/bin; end
          test -O ~/.aliases && source ~/.aliases
          for p in $HOME/.local/share/gem/ruby/*; fish_add_path --prepend $p/bin; end
          for p in /Applications/WezTerm.app/Contents/MacOS*; fish_add_path --prepend $p; end
          wezterm shell-completion --shell fish > $HOME/.config/fish/completions/wezterm.fish
        '';
        plugins = [
            { name = "fzf-fish"; inherit (pkgs.fishPlugins.fzf-fish) src; }
            { name = "tide"; inherit (pkgs.fishPlugins.tide) src; }
        ];
  };
}
