{ inputs, self, ... }:
{
  flake.homeModules.thunderbird =
    { pkgs, ... }:
    {
      programs.thunderbird = {
        enable = true;
        profiles.matt = {
          isDefault = true;
        };
      };
    };
}
