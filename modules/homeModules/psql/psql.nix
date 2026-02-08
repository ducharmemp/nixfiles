{ inputs, self, ... }:
{
  flake.homeModules.psql =
    { pkgs, ... }:
    {
      home.file = {
        ".psqlrc" = {
          source = ./psqlrc;
        };
      };
    };
}
