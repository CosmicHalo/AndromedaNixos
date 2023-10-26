_: rec {
  getSources = import ../../nix/sources.nix;

  getSource = source: getSources.${source};
}
