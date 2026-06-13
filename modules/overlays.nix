{ inputs, self, ... }:
{
  flake.overlays = {
    additions = final: _prev: import ../pkgs final;

    modifications = _final: _prev: { };

    unstable-packages = final: _prev: {
      unstable = import inputs.unstable {
        inherit (final) system;
        config.allowUnfree = true;
      };
    };
  };

  # Shared nixpkgs configuration reused by every platform's nix-settings
  # module (and the standalone rincewind home-manager config).
  flake.lib.nixpkgsSettings = {
    config.allowUnfree = true;
    overlays = [
      self.overlays.additions
      self.overlays.modifications
      self.overlays.unstable-packages
    ];
  };
}
