{
  description = "Matt DuCharme's Nix Configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    unstable-home-manager.url = "github:nix-community/home-manager/master";
    unstable-home-manager.inputs.nixpkgs.follows = "unstable";

    # Darwin
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    catppuccin.url = "github:catppuccin/nix/release-25.11";

    nixvim.url = "github:nix-community/nixvim";

    wezterm.url = "github:wez/wezterm?dir=nix";

    expert.url = "github:elixir-lang/expert";

    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      unstable-home-manager,
      unstable,
      nix-darwin,
      catppuccin,
      agenix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          formatter = forAllSystems (
            system:
            let
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
            in
            pkgs.writeShellApplication {
              name = "nixfmt-wrapper";

              runtimeInputs = [
                pkgs.fd
                pkgs.nixfmt-rfc-style
              ];

              text = ''
                fd "$@" -t f -e nix -x nixfmt '{}'
              '';
            }
          );
          default = pkgs.mkShell {
            packages =
              with pkgs;
              [
                statix
                shellcheck
                nil
              ]
              ++ [
                agenix.packages.${system}.default
              ];
          };
        }
      );

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        rincewind = unstable.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/rincewind/configuration.nix
          ];
        };
      };

      darwinConfigurations = {
        "CN-0171" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/workLaptop/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        "matt@rincewind" = unstable-home-manager.lib.homeManagerConfiguration {
          pkgs = unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            agenix.homeManagerModules.default
            catppuccin.homeModules.catppuccin
            ./home-manager/rincewind/home.nix
          ];
        };

        "matthewducharme" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            agenix.homeManagerModules.default
            catppuccin.homeModules.catppuccin
            ./home-manager/workLaptop/home.nix
          ];
        };
      };
    };
}
