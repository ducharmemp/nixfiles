{ self, ... }:
{
  flake.homeModules.nix-settings = {
    nixpkgs = self.lib.nixpkgsSettings;
  };
}
