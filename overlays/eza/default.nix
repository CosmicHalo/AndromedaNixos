{eza, ...}: final: _prev: {
  inherit (eza.packages.${final.system}) default;
}
