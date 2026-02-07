_: {
  programs.difftastic = {
    enable = true;
    git.diffToolMode = true;
  };

  programs.git = {
    enable = true;

    ignores = [
      "*.iml"
      ".DS_Store"
      ".solargraph.yml"
      ".direnv"
      "/direnv"
    ];

    settings = {
      user.name = "Matthew DuCharme";
      user.email = "ducharmemp@gmail.com";

      alias = {
        aliases = "!git config --get-regexp '^alias\\.' | cut -c 7- | sed 's/ / = /'";
        pu = "!git push --set-upstream origin $(git branch --show-current)";
        st = "status";
        aa = "add --all";
        co = "checkout";
        cane = "commit --amend --no-edit";
        cam = "commit --amend --message";
        fp = "push --force-with-lease";
        fixup = "!git commit --fixup";
      };

      pull = {
        ff = "only";
      };
      merge = {
        conflictstyle = "zdiff3";
        tool = "vimdiff";
      };
      rebase = {
        autosquash = true;
        autostash = true;
        updateRefs = true;
      };
      rerere = {
        enabled = true;
      };
      help = {
        autocorrect = 10;
      };
      diff = {
        algorithm = "histogram";
      };
      url."git@github.com:".insteadOf = "https://github.com/";
      transfer.fsckobjects = true;
      fetch.fsckobjects = true;
      receive.fsckObjects = true;
      maintenance.auto = true;
      maintenance.strategy = "incremental";
      gpg.format = "ssh";
    };
  };
}
