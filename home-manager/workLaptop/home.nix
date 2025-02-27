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
    ../common/fish.nix
    ../common/neovim.nix
    ../common/wezterm.nix
    ../common/psql.nix
  ];

  programs.git.ignores = [
    "**/flake.nix"
    "**/flake.lock"
    ".direnv"
    ".envrc"
  ];
  programs.git.extraConfig = {
    user.signingkey = "~/.ssh/id_ed25519.pub";
    commit.gpgsign = true; 
  };

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "matthewducharme";
    homeDirectory = "/Users/matthewducharme";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)) ++ [
    fontconfig
    fzf
    ripgrep
    htop
    nodejs_18
    (yarn.override {
      nodejs = nodejs_18;
    })
    awscli2
    libcxx
    libxml2
    libxslt
    freetds
    k9s
    babelfish
    git-absorb
    python312
    terraform
    fd
    tree-sitter
    unzip
    stylua
    zig
    du-dust
    gh
    tailwindcss-language-server
    teleport
    kubectl
  ];

  fonts.fontconfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.spotify-player.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
