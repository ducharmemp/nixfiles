{ inputs, self, ... }:
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

          revset-aliases = {
            "branch_start(to)" = "heads(::to & trunk())+ & ::to";
            "trunk()" = ''
            coalesce(
                remote_bookmarks(exact:'develop', exact:'develop'),
                latest(remote_bookmarks(exact:'develop')),
                bookmarks(exact:'develop'),
                latest(remote_bookmarks(glob:'{main,master,trunk}', glob:'{origin,upstream}')),
                latest(remote_bookmarks(glob:'{main,master,trunk}')),
                latest(bookmarks(glob:'{main,master,trunk}')),
            )'';
          };

          aliases = {
            collapse = ["squash" "-f" "branch_start(@)+::@" "-t" "branch_start(@)"];
            open = ["log" "-r" "heads(mine()) ~ ::trunk()"];
            nt = ["new" "trunk()"];
            sync = ["git" "fetch" "--all-remotes"];
          };

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

          signing.behavior = "own";
          signing.backend = "ssh";
        };
      };
    };
}
