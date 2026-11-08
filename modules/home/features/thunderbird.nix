_:
{
  flake.homeModules.thunderbird =
    _:
    {
      programs.thunderbird = {
        enable = true;
        profiles.matt = {
          isDefault = true;
        };
      };
    };
}
