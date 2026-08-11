{
  stdenvNoCC,
  fetchurl,
  darwin,
  cctools,
}:

# Rift ships prebuilt universal (x86_64 + arm64) macOS binaries per release.
# Building from source is impractical under Nix: build.rs links macOS private
# frameworks (SkyLight, MultitouchSupport) and the crate pulls git dependencies.
# The release tarball is the same artifact the upstream homebrew tap installs.
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rift";
  version = "0.5.3";

  src = fetchurl {
    url = "https://github.com/acsandmann/rift/releases/download/v${finalAttrs.version}/rift-universal-macos-${finalAttrs.version}.tar.gz";
    hash = "sha256-rQ1gM79deqtGKm6cXN5NGrhdLUK7QrhCWqhkPYaDh9g=";
  };

  # sigtool provides codesign and cctools provides codesign_allocate (needed to
  # re-sign the universal binary); the upstream binaries ship only a weak
  # "linker-signed" ad-hoc signature that fails `codesign --verify` and does not
  # anchor a stable CDHash. Re-signing gives a proper ad-hoc signature so macOS
  # TCC can persist the Accessibility grant rift needs to manage windows.
  nativeBuildInputs = [
    darwin.sigtool
    cctools
  ];

  # The tarball is a flat pair of binaries with no top-level directory.
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -Dm755 rift -t $out/bin
    install -Dm755 rift-cli -t $out/bin

    runHook postInstall
  '';

  # Re-sign after fixup so the final on-disk binary carries the stable signature.
  postFixup = ''
    codesign --force --sign - $out/bin/rift
    codesign --force --sign - $out/bin/rift-cli
  '';

  meta = {
    description = "Tiling window manager for macOS";
    homepage = "https://github.com/acsandmann/rift";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "rift";
  };
})
