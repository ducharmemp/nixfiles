{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "nomad-pack";
  version = "0.1.1";
  rev   = "99ab87eef98dfb0c59bdcc89b0dfedbf2087e540";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    inherit rev;
    sha256 = "sha256-Hy4FkOwFp9OqsH3eN+GbUM/JcF9xA3tdy/r+eZHZJjc=";
  };

  vendorHash = "sha256-5tLqjJ1XiGYomuwc51Qes5h9jkY/SETzYWh3A42Crq0=";

  # skip running go tests as they require network access
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/nomad-pack --version
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/hashicorp/nomad-pack";
    changelog = "https://github.com/hashicorp/nomad-pack/blob/main/CHANGELOG.md";
    description = "Nomad Pack is a templating and packaging tool used with HashiCorp Nomad.";
    license = licenses.mpl20;
    maintainers = [];
  };

}
