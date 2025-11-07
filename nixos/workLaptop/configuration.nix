# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    # inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    config.allowUnfree = true;
    config.allowUnfreePredicate = _: true;

    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = lib.mkDefault "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = lib.mkDefault config.nix.nixPath;
        download-buffer-size = 524288000;    
        trusted-users = [ "@admin" "matthewducharme" ];
        extra-trusted-users = [ "@admin" "matthewducharme" ];

        # automatic = lib.mkDefault true;
      };
      # Opinionated: disable channels
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mkForce(lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs);
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  # home-manager.useGlobalPkgs = true;

  environment.variables = {
    OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
    BROWSER_PATH = "${pkgs.google-chrome}/bin/google-chrome-stable";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    statix
    shellcheck
    google-chrome
    wezterm
    podman
    podman-compose
  ];

  users.knownUsers = [ "matthewducharme" ];
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
