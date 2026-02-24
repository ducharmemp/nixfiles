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
          user.name = "Matthew DuCharme";
          user.email = "ducharmemp@gmail.com";

          signing.behavior = "own";
          signing.backend = "ssh";
        };
      };
    };
}
