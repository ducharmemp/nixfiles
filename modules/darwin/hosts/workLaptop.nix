{ inputs, self, ... }:
{
  flake.darwinConfigurations.workLaptop = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      inputs.home-manager.darwinModules.home-manager
      { home-manager.sharedModules = [ self.homeModules.theme ]; }
      self.darwinModules.nix-settings
      self.darwinModules.workLaptop
    ];
  };

  flake.darwinModules.workLaptop =
    { pkgs, ... }:
    {
      nixpkgs.hostPlatform = "aarch64-darwin";
      ids.gids.nixbld = 350;
      nix.enable = false; # Leverage DetNix for this instead of nix-darwin

      nix.settings.trusted-users = [
        "matthewducharme"
        "@admin"
      ];
      nix.settings.extra-trusted-users = [
        "matthewducharme"
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
          home = "/Users/matthewducharme";
          shell = pkgs.fish;
        };
      };

      programs.fish.enable = true;
      system.defaults.NSGlobalDomain._HIHideMenuBar = true;
      system.defaults.CustomUserPreferences."com.apple.WindowManager".HideDesktopMenuBar = true;
      services.sketchybar.enable = true;
      services.jankyborders = {
        enable = true;
        style = "round";
        width = 6.0;
        hidpi = true;
        active_color = "0xfff0c6c6";
        inactive_color = "0xff363a4f";
      };
      home-manager.backupFileExtension = "backup";
      home-manager.users.matthewducharme = { config, ... }: {
        imports = [
          self.homeModules.jujutsu
          self.homeModules.git
          self.homeModules.nvim
          self.homeModules.wezterm
          self.homeModules.fish
          self.homeModules.oh-my-posh
          self.homeModules.psql
          self.homeModules.zellij
          self.homeModules.aerospace
          self.homeModules.sketchybar
          self.homeModules.browsers
          self.homeModules.common-packages
        ];

        home = {
          username = "matthewducharme";
          homeDirectory = "/Users/matthewducharme";
        };

        programs.git.settings = {
          user.signingkey = "~/.ssh/id_ed25519.pub";
          commit.gpgsign = true;
        };

        programs.jujutsu.settings = {
          signing.key = "~/.ssh/id_ed25519.pub";
        };

        home.packages = with pkgs; [
          devenv
          (yarn.override {
            nodejs = nodejs_22;
          })
          awscli2
          libcxx
          libxml2
          libxslt
          k9s
          python312
          terraform
          teleport_17
          kubectl
        ];

        programs.thunderbird.enable = true;
        programs.thunderbird.profiles.work = {
          isDefault = true;
        };

        programs.firefox.configPath = "${config.home.homeDirectory}/Library/Application Support/Firefox";
        programs.firefox.profiles.matt.path = "gma6439v.default-release";

        home.stateVersion = "25.11";
      };

      system.stateVersion = 4;
    };
}
