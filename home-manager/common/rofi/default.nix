{
  pkgs,
  config,
  ...
} : {
  programs.rofi = {
    cycle = true;
  }
}
