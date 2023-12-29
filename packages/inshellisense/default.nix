{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "inshellisense";
  version = "0.0.1-rc.4";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = "c42b6da63f8b33999c064b3bec0b4f4c767c46ce";
    hash = "sha256-PYSonVyclGSH3ArbqJuKrBNGbJaQEp6XemwnHboVwPk=";
  };

  npmDepsHash = "sha256-sjr4Hy1/zWPAlVGsMkyQIQcBT86KLaN2/UAaAd7Mn6Q=";

  meta = with lib; {
    description = "IDE style command line auto complete";
    homepage = "https://github.com/microsoft/inshellisense";
    license = licenses.mit;
    maintainers = [maintainers.malo];
  };
}
