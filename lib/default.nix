{
  lib,
  inputs,
  ...
}:
lib.andromeda.module
// {inherit (inputs.home-manager.lib) hm;}
// {
  ## Override a package's metadata
  override-meta = meta: package:
    package.overrideAttrs (attrs: {
      meta = (attrs.meta or {}) // meta;
    });
}
