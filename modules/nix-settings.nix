{ inputs, self, ... }:
{

  flake.homeModules.nix-settings =
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
    };

  flake.nixosModules.nix-settings =
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

      nix = {
        settings = {
          experimental-features = "nix-command flakes";
          nix-path = config.nix.nixPath;
          download-buffer-size = 524288000;
          auto-optimise-store = true;
        };
        channel.enable = false;
      };

      home-manager.useGlobalPkgs = true;
    };
}
