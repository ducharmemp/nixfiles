{ inputs, self, ... }:
{
  flake.overlays = {
    additions = final: _prev: import ../pkgs final;

    modifications = _final: prev: {
      sketchybar = prev.sketchybar.overrideAttrs (o: {
        patches = (o.patches or [ ]) ++ [ ../pkgs/patches/sketchybar-send-timeout.patch ];
      });
      sbarlua = prev.sbarlua.overrideAttrs (o: {
        patches = (o.patches or [ ]) ++ [ ../pkgs/patches/sbarlua-send-timeout.patch ];
      });
      zellij-unwrapped = prev.zellij-unwrapped.overrideAttrs (finalAttrs: _: {
        version = "0.46.0";
        src = prev.fetchFromGitHub {
          owner = "zellij-org";
          repo = "zellij";
          tag = "v${finalAttrs.version}";
          hash = "sha256-JpSNWC6jHahirUmnWRZKiVRonFjjIZx9j0V//6t1+iM=";
        };
        cargoDeps = prev.rustPlatform.fetchCargoVendor {
          inherit (finalAttrs) pname version src;
          hash = "sha256-i3Vh7w9YeGUkGIsbqA2UIiLtMqsSC+/ehdSDIfTckM8=";
        };
      });
    };

    unstable-packages = final: _prev: {
      unstable = import inputs.unstable {
        inherit (final.stdenv.hostPlatform) system;
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
      inputs.ghostty.overlays.default
    ];
  };
}
