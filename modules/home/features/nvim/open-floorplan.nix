{ inputs, ... }:
{
  flake.homeModules.nvim-open-floorplan =
    _:
    {
      programs.nixvim = {
        imports = [ inputs.open-floorplan.nixvimModules.default ];
        plugins.open-floorplan.enable = true;
      };
    };
}
