{ inputs, pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    package = pkgs.unstable.hyprland;
    portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    kdePackages.dolphin
    playerctl
  ];

  security.pam.services.hyprlock = { };
}
