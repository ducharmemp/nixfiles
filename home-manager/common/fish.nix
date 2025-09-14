{pkgs, ...}: {
    programs.oh-my-posh.enable = true;
    programs.oh-my-posh.useTheme = "catppuccin_macchiato";
    programs.fish = {
        enable = true;
        shellInit = ''
          set fish_greeting
          for p in $HOME/.local/share/gem/ruby/*; fish_add_path --prepend $p/bin; end
          fish_add_path --prepend /run/wrappers/bin
          set fzf_preview_dir_cmd eza --all --color=always
          set fzf_diff_highlighter delta --paging=never --width=20
        '';
        plugins = [
            { name = "fzf-fish"; inherit (pkgs.fishPlugins.fzf-fish) src; }
        ];
        shellAliases = {
          "l" = "eza -alh";
          "ll" = "eza -l";
          "find" = "fd";
          "ls" = "eza";
          "cat" = "bat";
          "man" = "batman";
        };
    };

    programs.eza.enable = true;
    programs.eza.enableFishIntegration = true;
    programs.bat.enable = true;
    programs.bat.extraPackages = [pkgs.bat-extras.batman];
    programs.fzf.enable = true;
    programs.fzf.enableFishIntegration = true;
    programs.fd.enable = true;
}
