{nixvim, ...}: _final: prev: {
  nixvim = nixvim.legacyPackages.${prev.system};
  nixvim-lib = nixvim.lib.${prev.system};
}
