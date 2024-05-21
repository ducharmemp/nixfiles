_: {
  programs.git = {
    enable = true;

    userName = "Matthew DuCharme";
    userEmail = "ducharmemp@gmail.com";

    delta = {
      enable = true;
      options = {
        line-numbers = true;
      };
    };

    extraConfig = {
      pull = { ff = "only"; };
      merge = { conflictstyle = "zdiff3"; };
      rebase = { autosquash = true; autostash = true; };
      rerere = { enabled = true; };
      help = { autocorrect = 10; };
      diff = { algorithm = "histogram"; };
      url."git@github.com:".insteadOf = "https://github.com/";
      transfer.fsckobjects = true;
      fetch.fsckobjects = true;
      receive.fsckObjects = true;
      maintenance.auto = false;
      maintenance.strategy = "incremental";
    };

    aliases = {
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

    ignores = [
      "*.iml"
      ".DS_Store"
      ".solargraph.yml"
    ];
  };
}
