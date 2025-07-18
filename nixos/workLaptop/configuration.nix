# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [];
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
    flake = {

  setFlakeRegistry = false;
  setNixPath = false;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  environment.variables = {
    OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
    BROWSER_PATH = "${pkgs.google-chrome}/bin/google-chrome-stable";
  };

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    # See https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986 for reasoning
    auto-optimise-store = false;
  };

  # FIXME: Add the rest of your current configuration
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    inputs.home-manager.packages.${pkgs.system}.default
    statix
    shellcheck
    google-chrome
    wezterm
    podman
    podman-compose
    aerospace
  ];

  users.knownUsers = ["matthewducharme"];
  system.primaryUser = "matthewducharme";
  users.users = {
    matthewducharme = {
      uid = 502;
      shell = pkgs.fish;
    };
  };

  programs.fish.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = 4;
}
