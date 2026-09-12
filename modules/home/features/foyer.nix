{ inputs, ... }:
{
  flake.homeModules.foyer =
    _:
    {
      imports = [ inputs.foyer.homeModules.foyer ];
      programs.foyer.enable = true;
    };
}
