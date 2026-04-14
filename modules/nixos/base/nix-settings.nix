{ inputs, self, ... }:
{
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
        gc = {
          automattic = true;
          dates = "daily";
          options = "--delete-older-than 30d";
        };
        channel.enable = false;
      };

      home-manager.useGlobalPkgs = true;
    };
}
