{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.system.env;
in {
  options.milkyway.system.env = with types;
    mkOption {
      default = {};
      type = attrsOf (oneOf [str path (listOf (either str path))]);
      apply = mapAttrs (_n: v:
        if isList v
        then concatMapStringsSep ":" toString v
        else (toString v));

      description = "A set of environment variables to set.";
    };

  config = {
    environment = {
      localBinInPath = true;

      sessionVariables = {
        # To prevent firefox from creating ~/Desktop.
        XDG_DESKTOP_DIR = "$HOME";
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_BIN_HOME = "$HOME/.local/bin";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
      };

      variables = {
        RADV_VIDEO_DECODE = "1";
        LESSHISTFILE = "$XDG_CACHE_HOME/less.history";
      };

      extraInit =
        concatStringsSep "\n"
        (mapAttrsToList (n: v: ''export ${n}="${v}"'') cfg);

      systemPackages = with pkgs; [
        xdg-utils
        xdg-ninja
        xdg-launch
        xdg-user-dirs
        xdg-dbus-proxy
      ];
    };
  };
}
