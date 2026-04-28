{ inputs, self, ... }:
{
  flake.darwinModules.nix-settings =
    { config, lib, ... }:
    {
      nixpkgs = {
        config.allowUnfree = true;
        config.allowUnfreePredicate = _: true;

        overlays = [
          self.overlays.additions
          self.overlays.modifications
          self.overlays.unstable-packages
        ];
      };

      home-manager.useGlobalPkgs = true;
    };
}
