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
    pkgs."ruby-3.2.3"
    pkgs.postgresql_15
    pkgs.awscli2
    pkgs.libcxx
    pkgs.libxml2
    pkgs.libxslt
    pkgs.openssl
    pkgs.freetds
    pkgs.k9s
  ];

  fonts.fontconfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;

    userName = "Matthew DuCharme";
    userEmail = "ducharmemp@gmail.com";

    delta = {
      enable = true;
      options = {
        line-numbers = true;
      };
    };

    aliases = {
      pu = "!git push --set-upstream origin $(git branch --show-current)";
      st = "status";
      aa = "add --all";
      co = "checkout";
      cane = "commit --amend --no-edit";
      cam = "commit --amend --message";
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''for p in (string split " " $NIX_PROFILES); fish_add_path --prepend --move $p/bin; end'';
    plugins = [
        { name = "fzf-fish"; inherit (pkgs.fishPlugins.fzf-fish) src; }
        {
          name = "tide";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "51b0f37307c7bcfa38089c2eddaad0bbb2e20c64";
            sha256 = "cCI1FDpvajt1vVPUd/WvsjX/6BJm6X1yFPjqohmo1rI=";
          };
        }
        { name = "bass"; inherit (pkgs.fishPlugins.bass) src; }
    ];
  };

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
