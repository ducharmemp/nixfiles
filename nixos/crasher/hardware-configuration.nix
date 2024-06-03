# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{ pkgs, ... }: {
  # fileSystems."/" = {
  #   device = "/dev/sda1";
  #   fsType = "ext4";
  # };

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    setLdLibraryPath = true;

    extraPackages = with pkgs; [
      mesa.drivers
      libvdpau-va-gl
      (libedit.overrideAttrs (attrs: { postInstall = (attrs.postInstall or "") + ''ln -s $out/lib/libedit.so $out/lib/libedit.so.2''; }))
    ];
  };
}

