{lib, ...}: let
  inherit (lib.milkyway) mkOpt;
  inherit (lib) types mkIf optionalString isString isAttrs isList;
in
  rec {
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

    isEmpty = x:
      if isString x
      then x == ""
      else if isAttrs x
      then x == {}
      else if isList x
      then x == []
      else null;
    isNotEmpty = x: ! (isEmpty x);

    ifNonNull = default: x: y:
      if (x == null)
      then default
      else y;
    ifNonNull' = x: y: (ifNonNull null x y);
    ifNonNullAttr = x: y: ifNonNull {} x y;

    mkIfNonNull = x: y: (mkIf (x != null) y);
    mkIfNonNull' = x: (mkIfNonNull x x);
    mkIfNonEmpty = x: y: (mkIf (isNotEmpty x) y);

    mkStringIf = cond: str:
      optionalString
      cond
      str;
    mkStringIfNonNull = cond: str: mkStringIf (cond != null) str;
    mkStringIfNonEmpty = cond: str: mkStringIf (isNotEmpty cond) str;

    ###############
    # Composite Options
    ###############

    # Creates an option with a composite type that defaults to empty set.
    mkCompositeOption = default: desc: options:
      mkOpt (types.submodule {inherit options;}) default desc;

    # Default is empty set
    mkCompositeOption' = desc: options: mkCompositeOption {} desc options;

    mkNullCompositeOption = default: desc: options:
      mkOpt (types.nullOr types.submodule {inherit options;}) default desc;
    # Default is null
    mkNullCompositeOption' = desc: options:
      mkOpt (types.nullOr (types.submodule {inherit options;})) null desc;
  }
  // import ./nullOpts.nix {inherit lib;}
