{pkgs, ...}: {
    programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting
      for p in (string split " " $NIX_PROFILES); fish_add_path --prepend --move $p/bin; end
    '';
    plugins = [
        { name = "fzf-fish"; inherit (pkgs.fishPlugins.fzf-fish) src; }
        { name = "tide"; inherit (pkgs.fishPlugins.tide) src; }
    ];
  };
}
