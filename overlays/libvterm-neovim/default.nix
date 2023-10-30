_: _final: prev: {
  libvterm-neovim = prev.libvterm-neovim.overrideAttrs (_: rec {
    doCheck = false;
    version = "0.3.3";
    src = prev.fetchurl {
      url = "https://launchpad.net/libvterm/trunk/v${prev.lib.versions.majorMinor version}/+download/libvterm-${version}.tar.gz";
      hash = "sha256-CRVvQ90hKL00fL7r5Q2aVx0yxk4M8Y0hEZeUav9yJuA=";
    };
  });
}
