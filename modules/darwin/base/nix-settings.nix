{ self, ... }:
{
  flake.darwinModules.nix-settings = {
    nixpkgs = self.lib.nixpkgsSettings;

    home-manager.useGlobalPkgs = true;
  };
}
