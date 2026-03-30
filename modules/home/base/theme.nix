{ inputs, self, ... }:
{
  flake.homeModules.theme =
    { ... }:
    {
      catppuccin.flavor = "macchiato";
      catppuccin.bat.enable = true;
      catppuccin.fzf.enable = true;
      catppuccin.k9s.enable = true;
      catppuccin.delta.enable = true;
      catppuccin.spotify-player.enable = true;
      catppuccin.thunderbird.enable = true;
    };
}
