{lib, ...}:
lib.andromeda.module
// {
  ## Override a package's metadata
  override-meta = meta: package:
    package.overrideAttrs (attrs: {
      meta = (attrs.meta or {}) // meta;
    });
}
