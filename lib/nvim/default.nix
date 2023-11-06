{lib, ...}: let
  inherit
    (lib)
    types
    hasAttr
    filterAttrs
    boolToString
    mkOptionType
    mapAttrsToList
    concatStringsSep
    mergeEqualOption
    concatMapStringsSep
    ;

  inherit (lib.milkyway) mkOpt ifNonNull' mkNullOrOption;
in {
  vim = rec {
    keymaps = import ./keymaps.nix {inherit lib;};

    # Black functional magic that converts a bunch of different Nix types to their
    # lua equivalents!
    toLuaObject = args:
      if builtins.isAttrs args
      then
        if hasAttr "__raw" args
        then args.__raw
        else if hasAttr "__empty" args
        then "{ }"
        else
          "{"
          + (concatStringsSep ","
            (mapAttrsToList
              (n: v:
                if (builtins.match "__unkeyed.*" n) != null
                then toLuaObject v
                else if n == "__emptyString"
                then "[''] = " + (toLuaObject v)
                else "[${toLuaObject n}] = " + (toLuaObject v))
              (filterAttrs
                (
                  _n: v:
                    v != null && (toLuaObject v != "{}")
                )
                args)))
          + "}"
      else if builtins.isList args
      then "{" + concatMapStringsSep "," toLuaObject args + "}"
      else if builtins.isString args
      then
        # This should be enough!
        builtins.toJSON args
      else if builtins.isPath args
      then builtins.toJSON (toString args)
      else if builtins.isBool args
      then "${boolToString args}"
      else if builtins.isFloat args
      then "${toString args}"
      else if builtins.isInt args
      then "${toString args}"
      else if (args == null)
      then "nil"
      else "";

    mkRaw = r: {__raw = r;};
    mkRawIfNonNull = v: ifNonNull' v (mkRaw v);
    isRawType = v: lib.isAttrs v && lib.hasAttr "__raw" v && lib.isString v.__raw;
    rawType = mkOptionType {
      name = "rawType";
      check = isRawType;
      merge = mergeEqualOption;
      descriptionClass = "noun";
      description = "raw lua code";
    };

    extraOptionsOptions = {
      extraOptions = mkOpt types.attrs {} ''
        These attributes will be added to the table parameter for the setup function.
        (Can override other attributes set by nixvim)
      '';
    };

    highlightType = with lib.types;
      submodule {
        # Adds flexibility for other keys
        freeformType = types.attrs;

        # :help nvim_set_hl()
        options = {
          bold = mkNullOrOption bool "";
          italic = mkNullOrOption bool "";
          reverse = mkNullOrOption bool "";
          standout = mkNullOrOption bool "";
          underline = mkNullOrOption bool "";
          undercurl = mkNullOrOption bool "";
          nocombine = mkNullOrOption bool "";
          underdouble = mkNullOrOption bool "";
          underdotted = mkNullOrOption bool "";
          underdashed = mkNullOrOption bool "";
          strikethrough = mkNullOrOption bool "";
          ctermfg = mkNullOrOption str "Sets foreground of cterm color.";
          ctermbg = mkNullOrOption str "Sets background of cterm color.";
          sp = mkNullOrOption str "Special color (color name or '#RRGGBB').";
          default = mkNullOrOption bool "Don't override existing definition.";
          link = mkNullOrOption str "Name of another highlight group to link to.";
          blend = mkNullOrOption (numbers.between 0 100) "Integer between 0 and 100.";
          fg = mkNullOrOption str "Color for the foreground (color name or '#RRGGBB').";
          bg = mkNullOrOption str "Color for the background (color name or '#RRGGBB').";
          cterm = mkNullOrOption attrs ''
            cterm attribute map, like |highlight-args|.
            If not set, cterm attributes will match those from the attribute map documented above.
          '';
        };
      };
  };
}
