{ inputs, self, ... }:
{
  flake.homeModules.jujutsu =
    { pkgs, ... }:
    {
      programs.delta = {
        enableJujutsuIntegration = true;
      };

      programs.jjui.enable = true;
      programs.jujutsu = {
        enable = true;
        package = pkgs.unstable.jujutsu;

        settings = {
          user.name = "***REMOVED***";
          user.email = "***REMOVED***";

          # signing.behavior = "own";
          # signing.backend = "ssh";
        };
      };
    };
}
