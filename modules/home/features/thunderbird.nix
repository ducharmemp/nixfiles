_:
{
  flake.homeModules.thunderbird =
    _:
    {
      programs.thunderbird = {
        enable = false;
        profiles.matt = {
          isDefault = true;
        };
      };
    };
}
