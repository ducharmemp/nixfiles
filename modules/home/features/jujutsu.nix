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
          user.name = inputs.profile.user.name;
          user.email = inputs.profile.user.email;

          # signing.behavior = "own";
          # signing.backend = "ssh";
        };
      };
    };
}
