{ pkgs ? import <nixpkgs> { } }: rec {
    nomad-pack-overridden = pkgs.callPackage ./nomad-pack-overridden { };
}
