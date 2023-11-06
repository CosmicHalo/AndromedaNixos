{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.milkyway.system.interface;
in {
  options.milkyway.system.interface = with types; {
    enable = mkEnableOption "macOS interface";
  };

  config = mkIf cfg.enable {
    system.defaults = {
      dock.autohide = true;

      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
      };

      NSGlobalDomain = {
        _HIHideMenuBar = false;
        AppleShowScrollBars = "Always";
      };
    };

    milkyway.home.file.".hushlogin".text = "";
  };
}
