{ inputs, ... }:
{
  flake.homeModules.hister =
    _:
    {
      imports = [ inputs.hister.homeModules.hister ];
      services.hister.enable = true;
    };
}
