_: {
  flake.nixosModules.vpn = _: {
    services.tailscale.enable = true;
  };
}
