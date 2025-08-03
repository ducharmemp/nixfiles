{ ... } : {
  programs.nixvim = {
    plugins.mini-surround.enable = true;
    plugins.mini-pairs.enable = true;
    plugins.mini-icons.enable = true;
    plugins.mini-statusline.enable = true;
    plugins.mini-extra.enable = true;
    plugins.mini-ai.enable = true;
    plugins.mini-starter = {
      enable = true;
      settings = {
        header = ''
           ▄   ▄███▄   ████▄  ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄
            █  █▀   ▀  █   █ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄
        ██   █ ██▄▄    █   █ ███    ███ ███▌ ███   ███   ███
        █ █  █ █▄   ▄▀ ▀████ ███    ███ ███▌ ███   ███   ███
        █  █ █ ▀███▀         ███    ███ ███  ███   ███   ███
        █   ██                ▀██████▀  █▀    ▀█   ███   █▀
        '';
      };
    };
  };
}
