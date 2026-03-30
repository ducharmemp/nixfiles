{ inputs, self, ... }:
{
  flake.homeModules.fish =
    { pkgs, ... }:
    {
      programs.oh-my-posh.enable = true;
      programs.oh-my-posh.enableFishIntegration = true;
      programs.oh-my-posh.settings = {
        "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
        version = 4;
        final_space = true;
        palette = {
          os = "#ACB0BE";
          closer = "p:os";
          pink = "#F5BDE6";
          lavender = "#B7BDF8";
          blue = "#8AADF4";
        };
        blocks = [
          {
            type = "prompt";
            alignment = "left";
            segments = [
              {
                foreground = "p:os";
                style = "plain";
                template = "{{.Icon}} ";
                type = "os";
              }
              {
                foreground = "p:blue";
                style = "plain";
                template = "{{ .UserName }}@{{ .HostName }} ";
                type = "session";
              }
              {
                foreground = "p:pink";
                properties = {
                  folder_icon = "..\\ue5fe..";
                  home_icon = "~";
                  style = "agnoster_short";
                };
                style = "plain";
                template = "{{ .Path }} ";
                type = "path";
              }
              {
                foreground = "p:lavender";
                style = "plain";
                type = "command";
                properties = {
                  shell = "bash";
                  command = "jj root --quiet 2>/dev/null && jj log -r@ --no-graph --ignore-working-copy -T 'change_id.shortest(4) ++ \" \" ++ bookmarks.join(\", \")' 2>/dev/null";
                };
                template = "\ue725 {{ .Output }} ";
              }
              {
                foreground = "p:lavender";
                style = "plain";
                type = "command";
                properties = {
                  shell = "bash";
                  command = "if ! jj root --quiet 2>/dev/null; then git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null; fi";
                };
                template = "\ue725 {{ .Output }} ";
              }
              {
                style = "plain";
                foreground = "p:closer";
                template = "\uf105";
                type = "text";
              }
            ];
          }
        ];
      };

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
          {
            name = "fzf-fish";
            inherit (pkgs.fishPlugins.fzf-fish) src;
          }
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
      programs.eza.git = true;
      programs.eza.enableFishIntegration = true;
      programs.bat.enable = true;
      programs.bat.extraPackages = [ pkgs.bat-extras.batman ];
      programs.fzf.enable = true;
      programs.fzf.enableFishIntegration = true;
      programs.fd.enable = true;
    };
}
