# This is your home-manager configuration filehomeyny
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ../common/git.nix
    ../common/neovim.nix
    ../common/wezterm.nix
    ../common/fish.nix
    ../common/psql.nix

    ./theme.nix
    ./ssh.nix
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
    username = "matt";
    homeDirectory = "/home/matt";
  };

  programs.git.extraConfig = {
    user.signingkey = "~/.ssh/id_ed25519.pub";
    commit.gpgsign = true; 
    gpg."ssh".program = "op-ssh-sign";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)) ++ [
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
    nodejs_23
    rclone

    ponyc
    pony-corral
  ];

  fonts.fontconfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.wezterm.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
