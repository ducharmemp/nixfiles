{ inputs, ... }:
{
  flake.overlays = {
    additions = final: _prev: import ../pkgs { pkgs = final; };

    modifications = final: prev: { };

    neovim-nightly = inputs.neovim-nightly-overlay.overlays.default;

    unstable-packages = final: _prev: {
      unstable = import inputs.unstable {
        inherit (final) system;
        config.allowUnfree = true;
      };
    };
  };
}
