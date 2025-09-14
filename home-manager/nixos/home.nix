{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ../common/git.nix
    ../common/nvim.nix
    ../common/wezterm.nix
    ../common/fish.nix
    ../common/psql.nix
    ../common/zellij.nix

    ./theme.nix
    ./ssh.nix
  ];

  home = {
    username = "matt";
    homeDirectory = "/home/matt";
  };

  catppuccin.thunderbird.enable = true;
  catppuccin.thunderbird.profile = "work";
  catppuccin.bat.enable = true;
  catppuccin.fzf.enable = true;
  catppuccin.k9s.enable = true;
  catppuccin.delta.enable = true;
  catppuccin.spotify-player.enable = true;
  catppuccin.flavor = "macchiato";

  programs.git.extraConfig = {
    user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIW24VUbwgiLgX4RNe+1KBNWdx6X3CPoYYfJZ37XCAi8";
    commit.gpgsign = true;
    gpg."ssh".program = "op-ssh-sign";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs;
    (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts))
    ++ [
      discord
      inter
      fzf
      ripgrep
      meslo-lgs-nf
      htop
      freetds
      babelfish
      git-absorb
      entr
      fd
      tree-sitter
      unzip
      stylua
      zig
      du-dust
      gh
      google-chrome
      ncdu
      zoom-us
      nodejs_22
      rclone
      obs-studio
    ];

  fonts.fontconfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.firefox.enable = true;
  programs.thunderbird.enable = true;
  programs.thunderbird.profiles.home = {
    isDefault = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
