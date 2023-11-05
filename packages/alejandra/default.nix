{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  alejandra,
}:
rustPlatform.buildRustPackage {
  name = "alejandra";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = "e53c2c6c6c103dc3f848dbd9fbd93ee7c69c109f";
    hash = "sha256-xFumnivtVwu5fFBOrTxrv6fv3geHKF04RGP23EsDVaI=";
  };

  cargoHash = "sha256-Onmn+yfxSjX/GaKTaq0c7URVdn6N2KWPu7h22d7Nn6s=";

  passthru.tests = {
    version = testers.testVersion {package = alejandra;};
  };

  meta = with lib; {
    description = "The Uncompromising Nix Code Formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    changelog = "https://github.com/kamadorueda/alejandra/blob/${version}/CHANGELOG.md";
    license = licenses.unlicense;
    maintainers = with maintainers; [_0x4A6F kamadorueda sciencentistguy lecoqjacob];
    mainProgram = "alejandra";
  };
}
