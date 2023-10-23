{lib, ...}: {
  # Check if pkgs contains a package with the given name
  hasPackage = pname: pkgs: lib.any (p: p ? pname && p.pname == pname) pkgs;
}
