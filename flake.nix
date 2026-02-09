{
  description = "Matt DuCharme's Nix Configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    import-tree.url = "github:vic/import-tree";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    unstable-home-manager.url = "github:nix-community/home-manager/master";
    unstable-home-manager.inputs.nixpkgs.follows = "unstable";

    # Darwin
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    catppuccin.url = "github:catppuccin/nix/release-25.11";

    nixvim.url = "github:nix-community/nixvim";

    wezterm.url = "github:wez/wezterm?dir=nix";

    expert.url = "github:elixir-lang/expert";

    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.home-manager.flakeModules.home-manager
        (inputs.import-tree ./modules)
      ];
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
    };
}
