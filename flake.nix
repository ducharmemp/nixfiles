{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "unstable";

    nixpkgs-ruby.url = "github:bobvanderlinden/nixpkgs-ruby";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    unstable,
    nix-darwin,
    nixpkgs-ruby,
    neovim-nightly-overlay,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    overlays = import ./overlays {inherit inputs outputs;};

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      crasher = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/crasher/configuration.nix];
      };
    };

    darwinConfigurations = {
      "CN-0082" = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/workLaptop/configuration.nix];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "ducharmemp@crasher" = home-manager.lib.homeManagerConfiguration {
        pkgs = import unstable {
          system = "x86_64-linux";
          overlays = [
            neovim-nightly-overlay.overlay
            nixpkgs-ruby.overlays.default
          ];
        };

        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/crasher/home.nix];
      };

      "matthewducharme@CN-0082" = home-manager.lib.homeManagerConfiguration {
        pkgs = import unstable {
          system = "x86_64-darwin";
          overlays = [
            nixpkgs-ruby.overlays.default
            neovim-nightly-overlay.overlay
          ];
        };
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/workLaptop/home.nix];
      };
    };
  };
}
