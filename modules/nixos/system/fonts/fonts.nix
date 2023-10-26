{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.system.fonts;

  localDir = ".local/share/fonts";
in {
  config = mkIf cfg.enable {
    milkyway.home.file = {
      "${localDir}/BerkleyMono".source = ./config/berkley;
      "${localDir}/PragmataPro".source = ./config/pragmata;
      "${localDir}/OpenDyslexic".source = ./config/open-dyslexic;
    };
  };
}
