{ inputs, ... }:
{
  flake.homeModules.nvim-straps =
    _:
    {
      programs.nixvim = {
        imports = [ inputs.straps.nixvimModules.default ];
        plugins.straps.enable = true;
      };
    };
}
