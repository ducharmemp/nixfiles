# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ../common/git.nix
    ../common/fish.nix
    ../common/packages.nix
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;

      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
    };
  };

  # TODO: Set your username
  home = {
    username = "matthewducharme";
    homeDirectory = "/Users/matthewducharme";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = [
    pkgs.fontconfig
    pkgs.nerdfonts
    pkgs.fzf
    pkgs.ripgrep
    pkgs.beam.interpreters.erlangR26
    pkgs.beam.packages.erlangR26.elixir_1_15
    pkgs.meslo-lgs-nf
    pkgs.htop
    pkgs.nodejs_18
    (pkgs.yarn.override {
      nodejs = pkgs.nodejs_18;
    })
    pkgs."ruby-3.0.6"
    pkgs.postgresql_15
    pkgs.awscli2
    pkgs.libcxx
    pkgs.libxml2
    pkgs.libxslt
    pkgs.openssl
    pkgs.freetds
    pkgs.k9s
    pkgs.babelfish
    pkgs.git-absorb
    pkgs.entr
    pkgs.python39
    pkgs.terraform
  ];

  fonts.fontconfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
