{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.system.env;
in {
  options.milkyway.system = with types; {
    env =
      mkOpt (attrsOf (oneOf [str path (listOf (either str path))])) {} "A set of environment variables to set."
      // {
        apply = mapAttrs (_n: v:
          if isList v
          then concatMapStringsSep ":" toString v
          else (toString v));
      };
  };

  config = {
    environment = {
      variables = {
        RADV_VIDEO_DECODE = "1";
        # Make some programs "XDG" compliant.
        WGETRC = "$XDG_CONFIG_HOME/wgetrc";
        LESSHISTFILE = "$XDG_CACHE_HOME/less.history";

        # To prevent firefox from creating ~/Desktop.
        XDG_DESKTOP_DIR = "$HOME";
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_BIN_HOME = "$HOME/.local/bin";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
      };

      extraInit =
        concatStringsSep "\n"
        (mapAttrsToList (n: v: ''export ${n}="${v}"'') cfg);
    };
  };
}
