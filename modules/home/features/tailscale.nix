_:
{
  flake.homeModules.tailscale =
    { pkgs, ... }:
    {
      services.trayscale.enable = true;
      home.packages = with pkgs; [ trayscale ];
    };
}
