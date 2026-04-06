{ inputs, self, ... }:
{
  flake.homeModules.zellij =
    { pkgs, ... }:
    {
      programs.zellij = {
        enable = true;
      };
    };
}
