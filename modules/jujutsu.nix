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
          user.name = "Matthew DuCharme";
          user.email = "ducharmemp@gmail.com";

          # signing.behavior = "own";
          # signing.backend = "ssh";
        };
      };
    };
}
