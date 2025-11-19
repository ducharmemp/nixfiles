{ pkgs, ... }:
{
  home.file = {
    ".psqlrc" = {
      source = ./psqlrc;
    };
  };
}
