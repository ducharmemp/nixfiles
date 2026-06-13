_:
{
  flake.homeModules.oh-my-posh =
    { pkgs, ... }:
    let
      base = builtins.fromJSON (builtins.readFile ./oh-my-posh.json);
    in
    {
      programs.oh-my-posh.enable = true;
      programs.oh-my-posh.package = pkgs.unstable.oh-my-posh;
      programs.oh-my-posh.enableFishIntegration = true;
      programs.oh-my-posh.settings = base // {
        palette = {
          os = "#585b70";
          closer = "p:os";
          pink = "#f5c2e7";
          lavender = "#b4befe";
          blue = "#89b4fa";
        };
      };
    };
}
