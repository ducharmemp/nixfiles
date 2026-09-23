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
        rift
      ];

      # Run rift as a per-user launchd agent. On first launch macOS prompts for
      # Accessibility permission for the rift binary; grant it, then the agent
      # keeps rift alive across logins. rift reads ~/.config/rift/config.toml.
      launchd.user.agents.rift = {
        serviceConfig = {
          ProgramArguments = [ "${pkgs.rift}/bin/rift" ];
          RunAtLoad = true;
          KeepAlive = true;
          ProcessType = "Interactive";
          StandardOutPath = "/tmp/rift.out.log";
          StandardErrorPath = "/tmp/rift.err.log";
        };
      };

      launchd.user.agents.sketchybar-watchdog = {
        serviceConfig = {
          ProgramArguments = [
            "${pkgs.writeShellApplication {
              name = "sketchybar-watchdog";
              runtimeInputs = [
                pkgs.coreutils
                pkgs.sketchybar
              ];
              text = ''
                state=/tmp/sketchybar-watchdog.failures
                if out=$(timeout -k 1 3 sketchybar --query bar 2>/dev/null) && [ -n "$out" ]; then
                  echo 0 > "$state"
                  exit 0
                fi
                failures=$(( $(cat "$state" 2>/dev/null || echo 0) + 1 ))
                if [ "$failures" -lt 2 ]; then
                  echo "$failures" > "$state"
                  exit 0
                fi
                echo 0 > "$state"
                service="gui/$(/usr/bin/id -u)/org.nixos.sketchybar"
                pid=$(/bin/launchctl print "$service" 2>/dev/null | awk '$1 == "pid" { print $3 }')
                echo "$(date '+%F %T') sketchybar unresponsive (pid ''${pid:-none}), restarting"
                /usr/bin/pkill -f 'sketchybar --trigger' || true
                if [ -n "$pid" ]; then
                  /usr/bin/pkill -KILL -P "$pid" || true
                fi
                /bin/launchctl kill SIGKILL "$service" || true
              '';
            }}/bin/sketchybar-watchdog"
          ];
          StartInterval = 60;
          StandardOutPath = "/tmp/sketchybar-watchdog.out.log";
          StandardErrorPath = "/tmp/sketchybar-watchdog.err.log";
        };
      };

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
          self.homeModules.foyer
          self.homeModules.git
          self.homeModules.nvim
          self.homeModules.wezterm
          self.homeModules.fish
          self.homeModules.oh-my-posh
          self.homeModules.psql
          self.homeModules.zellij
          self.homeModules.rift
          self.homeModules.sketchybar
          self.homeModules.browsers
          self.homeModules.common-packages
          self.homeModules.llms
        ];

        home = {
          username = "matthewducharme";
          homeDirectory = "/Users/matthewducharme";
        };

        programs.jujutsu.settings = {
          signing.key = "~/.ssh/id_ed25519_sign.pub";
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
