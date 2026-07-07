{ inputs, ... }:
{
  flake.homeModules.jujutsu =
    { pkgs, ... }:
    {
      programs.delta = {
        enable = true;
        enableJujutsuIntegration = true;
      };

      programs.git.ignores = [".attic"];

      programs.jjui.enable = true;
      programs.jujutsu = {
        enable = true;
        package = pkgs.unstable.jujutsu;

        settings = {
          user.name = inputs.profile.user.name;
          user.email = inputs.profile.user.email;

          "remotes.origin".auto-track-bookmarks = "*";

          revset-aliases = {
            "slice()" = "slice(@)";
            "slice(from)" = "ancestors(reachable(from, mutable()), 2)";
            "closest_merge(to)" = "heads(::to & merges())";
            "stack()" = "stack(@)";
            "stack(x)" = "stack(x, 2)";
            "stack(x, n)" = "ancestors(reachable(x, mutable()), n)";
            tip = "exactly(heads(@-::~@), 1)";
            "closest_pushable(to)"= "heads(::to & ~description(exact:\"\") & (~empty() | merges()))";
            "closest_bookmark(to)" = "heads(::to & bookmarks())";

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
            slice = ["log" "-r" "slice()"];
            collapse = ["squash" "-f" "branch_start(@)+::@" "-t" "branch_start(@)"];
            open = ["log" "-r" "heads(mine()) ~ ::trunk()"];
            nt = ["new" "trunk()"];
            sync = ["git" "fetch" "--all-remotes"];
            stack = ["rebase" "--after" "trunk()" "--before" "closest_merge(@)" "--revision"];
            restack = ["rebase" "-o" "trunk()" "-s" "roots(trunk()..) & stack()"];
            plan = ["new" "--no-edit" "heads(@::)" "-m"];
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
