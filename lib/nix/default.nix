{lib, ...}: rec {
  get-sources = import (lib.andromeda.fs.get-file "/nix/sources.nix");

  get-source = source: get-sources.${source};
  get-source-out = source: (get-source source).outPath;
}
