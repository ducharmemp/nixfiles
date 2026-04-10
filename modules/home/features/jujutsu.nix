{ inputs, self, lib, ... }:
{
  flake.homeModules.jujutsu =
    { pkgs, ... }:
    {
      programs.delta = {
        enable = true;
        enableJujutsuIntegration = true;
      };

      programs.jjui.enable = true;
      programs.jujutsu = {
        enable = true;
        package = pkgs.unstable.jujutsu;

        settings = {
          user.name = inputs.profile.user.name;
          user.email = inputs.profile.user.email;

          templates.draft_commit_description = ''
            concat(
              coalesce(description, default_commit_description, "\n"),
              surround(
                "\nJJ: This commit contains the following changes:\n", "",
                indent("JJ:     ", diff.stat(72)),
              ),
              "\nJJ: ignore-rest\n",
              diff.git(),
            )
          '';

          # signing.behavior = "own";
          # signing.backend = "ssh";
        };
      };
    };
}
