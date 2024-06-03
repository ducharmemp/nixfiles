{ lib, pkgs, ... }: {
  xdg = {
    configFile."wezterm" = {
      source = ./wezterm;
      recursive = true;
    };
  };

  home.activation.installWeztermProfile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    tempfile=$(mktemp) \
    && ${pkgs.curl}/bin/curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
    && tic -x -o ~/.terminfo $tempfile \
    && rm $tempfile
  '';
}
