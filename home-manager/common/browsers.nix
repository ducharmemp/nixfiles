{ pkgs, ... }:
{
  imports = [ ./firefox ];

  home.packages = with pkgs; [
    unstable.ladybird
    google-chrome
  ];
}
