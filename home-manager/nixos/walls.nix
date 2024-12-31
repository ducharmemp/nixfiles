{ inputs
, builtins
, home
, outputs
, lib
, config
, pkgs
, ...
}: {
  home.file."Pictures.wallpapers" = {
    source = builtins.fetchGit { url =  "https://github.com/dharmx/walls.git"; rev = "6bf4d733ebf2b484a37c17d742eb47e5139e6a14"; };
  };
}
