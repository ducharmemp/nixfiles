_:
{
  flake.homeModules.psql =
    _:
    {
      home.file = {
        ".psqlrc" = {
          source = ./psqlrc;
        };
      };
    };
}
