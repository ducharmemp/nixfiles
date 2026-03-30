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
          self.overlays.neovim-nightly
        ];
      };

      home-manager.useGlobalPkgs = true;
    };
}
