_:
{
  flake.homeModules.ghostty =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
        settings = {
          font-family = "BerkeleyMonoNerdFont Nerd Font";
          font-size = 14;
          adjust-underline-thickness = "-50%";
          shell-integration-features = "ssh-env,ssh-terminfo";
        };
      };
    };
}
