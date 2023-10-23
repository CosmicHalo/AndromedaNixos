{lib, ...}:
{
  ## Override a package's metadata
  override-meta = meta: package:
    package.overrideAttrs (attrs: {
      meta = (attrs.meta or {}) // meta;
    });
}
// lib.snowfall.module
