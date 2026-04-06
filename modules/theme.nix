{ inputs, ... }:
{
  flake.nixosModules.theme = {
    imports = [ inputs.catppuccin.nixosModules.catppuccin ];
    catppuccin.enable = true;
    catppuccin.flavor = "macchiato";
    catppuccin.accent = "flamingo";
  };
  flake.homeModules.theme = {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];
    catppuccin.enable = true;
    catppuccin.flavor = "macchiato";
    catppuccin.accent = "flamingo";
  };
}
