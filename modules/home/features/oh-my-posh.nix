{ inputs, self, ... }:
{
  flake.homeModules.oh-my-posh =
    { pkgs, config, ... }:
    let
      colors = config.lib.stylix.colors.withHashtag;
      base = builtins.fromJSON (builtins.readFile ./oh-my-posh.json);
    in
    {
      programs.oh-my-posh.enable = true;
      programs.oh-my-posh.package = pkgs.unstable.oh-my-posh;
      programs.oh-my-posh.enableFishIntegration = true;
      programs.oh-my-posh.settings = base // {
        palette = {
          os = colors.base04;
          closer = "p:os";
          pink = colors.base06;
          lavender = colors.base07;
          blue = colors.base0D;
        };
      };
    };
}
