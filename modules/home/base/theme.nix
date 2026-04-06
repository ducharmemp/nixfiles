{ inputs, self, ... }:
{
  flake.homeModules.theme =
    { pkgs, ... }:
    {
      stylix.enable = true;
      stylix.autoEnable = true;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
      stylix.image = null;
    };
}
