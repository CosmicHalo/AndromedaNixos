{lib, ...}: let
  inherit (lib) mkIf;
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

  mkIfNonNull' = x: y: (mkIf (x != null) y);
  mkIfNonNull = x: (mkIfNonNull' x x);
  ifNonNull' = x: y:
    if (x == null)
    then null
    else y;
}
