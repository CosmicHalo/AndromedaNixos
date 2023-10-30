_: final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.override {
    inherit (prev.llvmPackages_latest) stdenv;
    inherit (final) libvterm-neovim;
  };
}
