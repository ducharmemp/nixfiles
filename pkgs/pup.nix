{
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pup";
  version = "1.23.4";

  src = fetchurl {
    url = "https://github.com/DataDog/pup/releases/download/v${finalAttrs.version}/pup_${finalAttrs.version}_Darwin_arm64.tar.gz";
    hash = "sha256-fIkOyKCeS81tctNW5rEN4KcBsVydYc2oIA/9aIAnBhs=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -Dm755 pup -t $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Datadog CLI";
    homepage = "https://github.com/DataDog/pup";
    platforms = [ "aarch64-darwin" ];
    mainProgram = "pup";
  };
})
