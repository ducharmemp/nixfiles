{
   lib,
   requireFile,
   stdenvNoCC,
   unzip,
   nerd-font-patcher,
   variant ? "26030184XPX2RZ98",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
   pname = "berkeley-mono";
   version = "1.009";

   src = requireFile rec {
      name = "${variant}.zip";
      sha256 = "0yjjck6j86xm201g4ws164q7pl56kdwfrizah4p118291qw30s1h";
      message = ''
         This file needs to be manually downloaded from the Berkeley Graphics
         site (https://berkeleygraphics.com/accounts). An email will be sent to
         get a download link.

         Download the zip file then run:

         Then run:

         nix-prefetch-url --type sha256 file://\$PWD/26030184XPX2RZ98.zip
      '';
   };

   nativeBuildInputs = [
      unzip
      nerd-font-patcher
   ];

   unpackPhase = ''
      unzip $src
   '';

   installPhase = ''
      runHook preInstall

      mkdir -p patched
      find . -name '*.ttf' -exec nerd-font-patcher --complete {} --outputdir patched \;

      install -D -m444 -t $out/share/fonts/truetype patched/*.ttf

      runHook postInstall
   '';

   meta = {
      # …
   };
})
