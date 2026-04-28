{ inputs, ... }:
{
  flake.overlays = {
    additions = final: _prev: import ../pkgs final;

    modifications = final: prev: { };

    unstable-packages = final: _prev: {
      unstable = import inputs.unstable {
        inherit (final) system;
        config.allowUnfree = true;
      };
    };
  };
}
