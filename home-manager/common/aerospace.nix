{pkgs, ...}: {
  programs.aerospace = {
    enable = true;
    userSettings = {
      start-at-login = true;
      automatically-unhide-macos-hidden-apps = true;
    };
  };
}
