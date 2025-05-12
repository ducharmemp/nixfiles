{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "unstable";

    mac-app-util.url = "github:hraban/mac-app-util";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixos-cosmic.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    unstable,
    nix-darwin,
    neovim-nightly-overlay,
    nixos-cosmic,
    mac-app-util,
    catppuccin,
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
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
            }
            nixos-cosmic.nixosModules.default
            ./nixos/nixos/configuration.nix
          ];
      };
    };

    darwinConfigurations = {
      "CN-0171" = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [mac-app-util.darwinModules.default ./nixos/workLaptop/configuration.nix];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
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
        modules = [./home-manager/nixos/home.nix];
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
