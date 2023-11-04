{lib, ...}: let
  inherit
    (lib)
    head
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

  inherit (lib.milkyway) mkOpt ifNonNull';
in {
  vim = rec {
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

    # Creates an option with a nullable type that defaults to null.
    mkNullOrOption = type: desc:
      mkOpt (types.nullOr type) null desc;

    defaultNullOpts = rec {
      mkNullable = type: default: desc:
        mkNullOrOption type (
          let
            defaultDesc = "default: `${default}`";
          in
            if desc == ""
            then defaultDesc
            else ''
              ${desc}

              ${defaultDesc}
            ''
        );

      mkInt = default: mkNullable lib.types.int (toString default);
      mkNum = default: mkNullable lib.types.number (toString default);
      # Positive: >0
      mkPositiveInt = default: mkNullable lib.types.ints.positive (toString default);
      # Unsigned: >=0
      mkUnsignedInt = default: mkNullable lib.types.ints.unsigned (toString default);

      mkBool = default:
        mkNullable lib.types.bool (
          if default
          then "true"
          else "false"
        );

      mkStr = default: mkNullable lib.types.str ''${builtins.toString default}'';

      mkEnumFirstDefault = enum: mkEnum enum (head enum);
      mkAttributeSet = default: mkNullable lib.types.attrs ''${default}'';
      mkEnum = enum: default: mkNullable (lib.types.enum enum) ''"${default}"'';
    };
  };
}
