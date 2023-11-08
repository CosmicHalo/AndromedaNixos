{lib, ...}: let
  inherit (lib) types head;
  inherit (lib.milkyway) mkNullOrOption mkOpt;
in {
  ###########
  # Null Options
  ###########

  # Creates an option with a nullable type that defaults to null.
  mkNullOrOption = type: desc:
    mkOpt (types.nullOr type) null desc;

  defaultNullOpts = rec {
    mkNullable = type: default: desc: let
      defaultDesc = "default: `${default}`";
      description =
        if desc == ""
        then defaultDesc
        else ''
          ${desc}

          ${defaultDesc}
        '';
    in
      mkNullOrOption type description;

    # Bool
    mkBool = default:
      mkNullable lib.types.bool (
        if default
        then "true"
        else "false"
      );

    # Str
    mkStr = default: mkNullable lib.types.str ''${builtins.toString default}'';
    mkLines = default: mkNullable lib.types.lines ''${builtins.toString default}'';

    # Number
    mkInt = default: mkNullable lib.types.int (toString default);
    mkNum = default: mkNullable lib.types.number (toString default);
    # Positive: >0
    mkPositiveInt = default: mkNullable lib.types.ints.positive (toString default);
    # Unsigned: >=0
    mkUnsignedInt = default: mkNullable lib.types.ints.unsigned (toString default);

    #Attrs
    mkAttrs = default: mkNullable lib.types.attrs ''${default}'';
    mkAttrsOf = of: default: mkNullable (lib.types.attrsOf of) ''${default}'';

    # Enum
    mkEnumFirstDefault = enum: mkEnum enum (head enum);
    mkEnum = enum: default: mkNullable (lib.types.enum enum) ''"${default}"'';
  };
}
