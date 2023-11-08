{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.system.configuration;
in {
  options.milkyway.system.configuration = with types; {
    enable = mkBoolOpt true "Whether or not to enable common system features.";
    nodocs = mkBoolOpt true "Whether or not to disable documentation.";
  };

  config = mkIf cfg.enable {
    /*
     ***************************************************************
    * WHO NEEDS DOCUMENTATION WHEN THERE IS THE INTERNET? #BL04T3D *
    ***************************************************************
    */
    documentation = mkIf cfg.nodocs {
      enable = true;

      doc.enable = false;
      info.enable = false;
      man.enable = false;
    };

    system = {
      # # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
      # activationScripts.postUserActivation.text = ''
      #   # activateSettings -u will reload the settings from the database and apply them to the current session,
      #   # so we do not need to logout and login again to make the changes take effect.
      #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      # '';
    };
  };
}
