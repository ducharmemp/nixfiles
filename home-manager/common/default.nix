{
  config,
  outputs,
  ...
}:
{
  nixpkgs = {
    config.allowUnfree = true;
    config.allowUnfreePredicate = _: true;

    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };
}
