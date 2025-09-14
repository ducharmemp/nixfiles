{ config, pkgs, lib, inputs, outputs, ... }:
  nixpkgs = {
    config.allowUnfree = true;
    config.allowUnfreePredicate = _: true;

    overlays = [
      outputs.overlays.unstable-packages
    ];
  };
}
