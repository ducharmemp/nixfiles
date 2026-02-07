{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../common
    ../common/git.nix
    ../common/fish.nix
    ../common/nvim.nix
    ../common/wezterm.nix
    ../common/psql.nix
    ../common/zellij.nix
    ../common/aerospace.nix
  ];

  catppuccin.thunderbird.enable = true;
  catppuccin.thunderbird.profile = "work";
  catppuccin.bat.enable = true;
  catppuccin.fzf.enable = true;
  catppuccin.k9s.enable = true;
  catppuccin.delta.enable = true;
  catppuccin.spotify-player.enable = true;
  catppuccin.flavor = "macchiato";
  programs.git.ignores = [
    "**/flake.nix"
    "**/flake.lock"
    ".direnv"
  ];

  programs.git.settings = {
    user.signingkey = "~/.ssh/id_ed25519.pub";
    commit.gpgsign = true;
  };

  home = {
    username = "matthewducharme";
    homeDirectory = "/Users/matthewducharme";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages =
    with pkgs;
    (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts))
    ++ [
      devenv
      fzf
      ripgrep
      htop
      nodejs_22
      (yarn.override {
        nodejs = nodejs_22;
      })
      awscli2
      libcxx
      libxml2
      libxslt
      freetds
      k9s
      babelfish
      python312
      terraform
      fd
      tree-sitter
      unzip
      stylua
      zig
      dust
      gh
      teleport_17
      kubectl
    ];

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.thunderbird.enable = true;
  programs.thunderbird.profiles.work = {
    isDefault = true;
  };

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
