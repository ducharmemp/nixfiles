{ config, lib, pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };
}
