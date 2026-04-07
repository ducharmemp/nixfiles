{ inputs, ... }:
{
  flake.nixosModules.theme = {
    imports = [ inputs.catppuccin.nixosModules.catppuccin ];
    catppuccin.enable = true;
    catppuccin.flavor = "macchiato";
    catppuccin.accent = "flamingo";
  };
  flake.homeModules.theme =
    { config, ... }:
    {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];
      catppuccin.enable = true;
      catppuccin.flavor = "macchiato";
      catppuccin.accent = "flamingo";
      catppuccin.nvim.enable = true;
      catppuccin.wezterm = {
        enable = true;
        apply = true;
      };
      programs.nixvim.colorschemes.catppuccin = {
        enable = true;
        settings.flavour = config.catppuccin.flavor;
      };
    };
}
