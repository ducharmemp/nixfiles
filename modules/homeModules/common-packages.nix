{ inputs, self, ... }:
{
  flake.homeModules.common-packages =
    { pkgs, lib, ... }:
    {
      home.packages =
        with pkgs;
        (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts))
        ++ [
          fzf
          ripgrep
          htop
          freetds
          babelfish
          fd
          tree-sitter
          unzip
          stylua
          zig
          dust
          gh
          nodejs_22
        ];

      fonts.fontconfig.enable = true;

      programs.home-manager.enable = true;

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
