{ inputs, ... }:
{
  flake.nixosModules.theme = {
    imports = [ inputs.catppuccin.nixosModules.catppuccin ];
    catppuccin.enable = true;
    catppuccin.flavor = "macchiato";
    catppuccin.accent = "flamingo";
  };
  flake.homeModules.theme =
    { config, lib, ... }:
    {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];
      catppuccin.enable = true;
      catppuccin.flavor = "macchiato";
      catppuccin.accent = "flamingo";
      catppuccin.nvim.enable = true;
      # catppuccin's release-26.05 gemini-cli module sets the old
      # `programs.gemini-cli.settings` path, renamed to `antigravity-cli` in
      # our `unstable` home-manager. We do not use gemini-cli, so disable the
      # integration to drop the deprecation warning.
      catppuccin.gemini-cli.enable = false;
      catppuccin.wezterm = {
        enable = true;
        apply = true;
      };
      programs.nixvim.colorschemes.catppuccin = {
        enable = true;
        settings.flavour = config.catppuccin.flavor;
      };
      programs.nixvim.colorschemes.cyberdream.enable = true;
      programs.nixvim.colorschemes.tokyonight.enable = true;
      programs.nixvim.colorschemes.kanagawa.enable = true;
      programs.nixvim.colorschemes.gruvbox.enable = true;
      programs.nixvim.colorscheme = lib.mkForce "catppuccin";
    };
}
