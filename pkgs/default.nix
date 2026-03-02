# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  berkeley-mono = pkgs.callPackage ./berkeley-mono.nix { };
}
