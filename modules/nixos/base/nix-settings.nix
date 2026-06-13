{ self, ... }:
{
  flake.nixosModules.nix-settings =
    { config, ... }:
    {
      nixpkgs = self.lib.nixpkgsSettings;

      nix = {
        settings = {
          experimental-features = "nix-command flakes";
          nix-path = config.nix.nixPath;
          download-buffer-size = 524288000;
          auto-optimise-store = true;
        };
        gc = {
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 30d";
        };
        channel.enable = false;
      };

      home-manager.useGlobalPkgs = true;
    };
}
