{lib, ...}: rec {
  getSources = import (lib.andromeda.fs.get-file "/nix/sources.nix");
  getSource = source: getSources.${source};
}
