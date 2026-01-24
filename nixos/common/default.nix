{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-gaming.nixosModules.platformOptimizations
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    ./audio.nix
    ./printing.nix
    ./vpn.nix
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
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
        download-buffer-size = 524288000;
        auto-optimise-store = true;
      };
      # Opinionated: disable channels
      channel.enable = false;
    };

  home-manager.useGlobalPkgs = true;

  programs.steam.platformOptimizations.enable = true;
}
