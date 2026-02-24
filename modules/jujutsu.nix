{ inputs, self, ... }:
{
  flake.homeModules.jujutsu =
    { pkgs, ... }:
    {
      programs.delta = {
        enableJujutsuIntegration = true;
      };

      programs.jujutsu = {
        enable = true;

        settings = {
          user.name = "***REMOVED***";
          user.email = "***REMOVED***";

          signing.behavior = "own";
          signing.backend = "ssh";
        };
      };
    };
}
