{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../common
    ./hardware-configuration.nix
    inputs.home-manager.darwinModules.home-manager
  ];

  nix.settings.trusted-users = [
    "matt"
    "@admin"
  ];
  nix.settings.extra-trusted-users = [
    "matt"
    "@admin"
  ];

  environment.variables = {
    OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
    BROWSER_PATH = "${pkgs.google-chrome}/bin/google-chrome-stable";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    statix
    shellcheck
    google-chrome
    wezterm
    podman
    podman-compose
    home-manager
    aerospace
  ];

  users.knownUsers = [ "matthewducharme" ];
  system.primaryUser = "matthewducharme";
  users.users = {
    matthewducharme = {
      uid = 502;
      shell = pkgs.fish;
    };
  };

  programs.fish.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = 4;
}
