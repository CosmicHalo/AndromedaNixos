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
      "${localDir}/BerkleyMono".source = ./berkley;
      "${localDir}/PragmataPro".source = ./pragmata;
      "${localDir}/OpenDyslexic".source = ./open-dyslexic;
    };
  };
}
