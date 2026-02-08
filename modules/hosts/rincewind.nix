{
  inputs,
  outputs,
  self,
  ...
}:
{
  flake.homeConfigurations."matt@rincewind" =
    inputs.unstable-home-manager.lib.homeManagerConfiguration
      {
        pkgs = inputs.unstable.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs self; };
        modules = [
          inputs.agenix.homeManagerModules.default
          inputs.catppuccin.homeModules.catppuccin
          self.homeModules.nix-settings
          self.homeModules.matt
        ];
      };

  flake.nixosConfigurations.rincewind = inputs.unstable.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.nix-settings
      self.nixosModules.audio
      self.nixosModules.kernel
      self.nixosModules.printing
      self.nixosModules.vpn
      self.nixosModules.rincewind-hardware
      self.nixosModules.rincewind
    ];
  };

  flake.nixosModules.rincewind =
    { lib, pkgs, ... }:
    {
      nix.settings.trusted-users = [ "matt" ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

      hardware.graphics.enable = true;
      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver
      ];

      networking.hostName = "rincewind";

      zramSwap.enable = true;

      networking.networkmanager.enable = true;

      time.timeZone = "America/New_York";

      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      services.thermald.enable = true;
      services.system76-scheduler.enable = true;

      services.displayManager.cosmic-greeter.enable = true;
      services.desktopManager.cosmic.xwayland.enable = true;
      services.desktopManager.cosmic.enable = true;

      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      services.libinput.enable = true;

      services.fprintd.enable = true;

      users.users.matt = {
        isNormalUser = true;
        shell = pkgs.fish;
        description = "Matt";
        extraGroups = [
          "networkmanager"
          "wheel"
          "libvirtd"
          "podman"
        ];
        packages = with pkgs; [
          vim
          git
          thunderbird
        ];
      };

      programs.fish.enable = true;
      programs.zoom-us.enable = true;
      programs.obs-studio.enable = true;
      programs.firefox.enable = true;
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
      programs._1password.enable = true;
      programs._1password-gui = {
        enable = true;
        polkitPolicyOwners = [ "matt" ];
      };

      environment.systemPackages = with pkgs; [
        vim
        wget
        virtiofsd
      ];

      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      virtualisation.libvirtd.enable = true;

      programs.virt-manager.enable = true;
      programs.nix-ld.enable = true;

      system.stateVersion = "25.05";
    };
}
