{fenix, ...}: final: _prev: {
  inherit (fenix.packages.${final.system}.default) toolchain;
}
