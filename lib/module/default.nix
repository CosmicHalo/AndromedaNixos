{lib, ...}: let
  inherit (builtins) isNull;
  inherit (lib) types mkIf head optionalString;
  inherit (lib.andromeda.module) mkOpt;
in rec {
  isEnabled = option: config: let
    options =
      (lib.splitString "." option)
      ++ ["enable"];
  in
    if lib.hasAttrByPath options config
    then (lib.attrByPath options false config)
    else lib.warn "${option} is not found within config";

  isMilkyWayEnabled = option: config: (isEnabled "milkyway.${option}" config);

  # Helper Functions
  isNyxEnabled = config: isMilkyWayEnabled "nix.chaotic-nyx" config;

  #************
  #* Options
  #************

  mkIfNonNull' = x: y: (mkIf (!x != null) y);
  mkIfNonNull = x: (mkIfNonNull' x x);
  ifNonNull' = x: y:
    if (x == null)
    then null
    else y;
  mkStringIfNonNull = x: y:
    optionalString
    (x != null)
    y;

  # Creates an option with a nullable type that defaults to null.
  mkNullOrOption = type: desc:
    mkOpt (types.nullOr type) null desc;

  # Creates an option with a composite type that defaults to empty set.
  mkCompositeOption = default: desc: options:
    mkOpt (types.submodule {inherit options;}) {} desc;

  # Default is null
  mkNullCompositeOption' = desc: mkCompositeOption null desc;
  # Default is empty set
  mkCompositeOption' = desc: options: mkCompositeOption {} desc options;

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

    # Creates an option with an example
    mkOptWithExample = type: default: desc: example:
      (mkNullable type default desc) // {inherit example;};

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
    mkLines = default: mkNullable lib.types.lines ''${builtins.toString default}'';

    mkEnumFirstDefault = enum: mkEnum enum (head enum);
    mkAttributeSet = default: mkNullable lib.types.attrs ''${default}'';
    mkEnum = enum: default: mkNullable (lib.types.enum enum) ''"${default}"'';
  };
}
