{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "unstable";

    mac-app-util.url = "github:hraban/mac-app-util";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    catppuccin.url = "github:catppuccin/nix";

    nixvim.url = "github:nix-community/nixvim";
    nur.url = "github:nix-community/nur";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    wezterm.url = "github:wez/wezterm?dir=nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    unstable,
    nix-darwin,
    neovim-nightly-overlay,
    mac-app-util,
    catppuccin,
    nixvim,
    firefox-addons,
    ...
  } @ inputs: let
overlays = import ./overlays {inherit inputs outputs;};
    inherit (self) outputs;
  in {
    overlays = import ./overlays {inherit inputs outputs;};

    devShells = {
      x86_64-linux.default = 
          let pkgs = nixpkgs.legacyPackages.x86_64-linux;
          in pkgs.mkShell {
        packages = [pkgs.statix];
      };

      aarch64-darwin.default = 
          let pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          in pkgs.mkShell {
        packages = [pkgs.statix];
      };
    };

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
            ./nixos/nixos/configuration.nix
          ];
      };
      rincewind = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
            ./nixos/rincewind/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
      };
    };

    darwinConfigurations = {
      "CN-0171" = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [mac-app-util.darwinModules.default ./nixos/workLaptop/configuration.nix];
      };
    };

    homeConfigurations = {
      "matt@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = import unstable {
          system = "x86_64-linux";
          overlays = [
            neovim-nightly-overlay.overlays.default
            overlays.unstable-packages
          ];
        };

        extraSpecialArgs = {inherit inputs outputs;};
        modules = [catppuccin.homeModules.catppuccin ./home-manager/nixos/home.nix];
      };

      "matt@rincewind" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [
            neovim-nightly-overlay.overlays.default
            firefox-addons.overlays.default
            overlays.unstable-packages
          ];
        };

        extraSpecialArgs = {inherit inputs outputs;};
        modules = [catppuccin.homeModules.catppuccin ./home-manager/rincewind/home.nix];
      };

      "matthewducharme" = home-manager.lib.homeManagerConfiguration {
        pkgs = import unstable {
          system = "aarch64-darwin";
          overlays = [
            neovim-nightly-overlay.overlays.default
            overlays.unstable-packages
          ];
        };
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [catppuccin.homeModules.catppuccin mac-app-util.homeManagerModules.default ./home-manager/workLaptop/home.nix];
      };
    };
  };
}
