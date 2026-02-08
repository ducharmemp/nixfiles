{ inputs, self, ... }:
{
  flake.darwinModules.nix-settings =
    { config, lib, ... }:
    {
      nixpkgs = {
        config.allowUnfree = true;
        config.allowUnfreePredicate = _: true;

        overlays = [
          self.overlays.additions
          self.overlays.modifications
          self.overlays.unstable-packages
          self.overlays.neovim-nightly
        ];
      };

      home-manager.useGlobalPkgs = true;
    };

  flake.darwinConfigurations.workLaptop = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      inputs.home-manager.darwinModules.home-manager
      self.darwinModules.nix-settings
      self.darwinModules.workLaptop
    ];
  };

  flake.darwinModules.workLaptop =
    { lib, pkgs, ... }:
    {
      nixpkgs.hostPlatform = "aarch64-darwin";
      ids.gids.nixbld = 350;

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

      home-manager.users.matthewducharme = {
        imports = [
          self.homeModules.git
          self.homeModules.nvim
          self.homeModules.wezterm
          self.homeModules.fish
          self.homeModules.psql
          self.homeModules.zellij
          self.homeModules.aerospace
          self.homeModules.theme
          self.homeModules.common-packages
          inputs.catppuccin.homeModules.catppuccin
        ];

        home = {
          username = "matthewducharme";
          homeDirectory = "/Users/matthewducharme";
        };

        catppuccin.thunderbird.profile = "work";

        programs.git.ignores = [
          "**/flake.nix"
          "**/flake.lock"
          ".direnv"
        ];

        programs.git.settings = {
          user.signingkey = "~/.ssh/id_ed25519.pub";
          commit.gpgsign = true;
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

        home.stateVersion = "25.05";
      };

      system.stateVersion = 4;
    };
}
