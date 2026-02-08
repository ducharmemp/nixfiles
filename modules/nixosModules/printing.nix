_: {
  flake.nixosModules.printing =
    { pkgs, ... }:
    {
      services.printing.enable = true;
      services.printing.drivers = [ pkgs.brlaser ];
    };
}
