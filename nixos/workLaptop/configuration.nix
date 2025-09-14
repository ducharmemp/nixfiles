# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    ../common

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  nix.settings = {
    # Deduplicate and optimize nix store
    # See https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986 for reasoning
    auto-optimise-store = false;
  };

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
