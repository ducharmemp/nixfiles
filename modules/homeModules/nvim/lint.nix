{ inputs, self, ... }:
{
  flake.homeModules.glint =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins.lint.enable = true;
      };
    };
}
