# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
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
    "${fetchTarball { url = "https://github.com/msteen/nixos-vscode-server/tarball/master"; sha256 = "0sz8njfxn5bw89n6xhlzsbxkafb6qmnszj4qxy2w0hw2mgmjp829"; }}/modules/vscode-server/home.nix"
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
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
    username = "ducharmemp";
    homeDirectory = "/home/ducharmemp";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    fontconfig
    nerdfonts
    fzf
    ripgrep
    beam.interpreters.erlangR26
    beam.packages.erlangR26.elixir_1_15
    meslo-lgs-nf
    htop
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
      st = "status";
      aa = "add --all";
      co = "checkout";
      cane = "commit --amend --no-edit";
      cam = "commit --amend --message";
    };
  };

  programs.fish = {
    enable = true;
    plugins = [
        { name = "fzf-fish"; inherit (pkgs.fishPlugins.fzf-fish) src; }
        { name = "tide"; inherit (pkgs.fishPlugins.tide) src; }
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  services.vscode-server.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
