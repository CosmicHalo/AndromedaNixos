{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.fonts;

  localDir = ".local/share/fonts";
in {
  config = mkIf cfg.enable {
    home.file = {
      "${localDir}/BerkleyMono".source = ./config/berkley;
      "${localDir}/PragmataPro".source = ./config/pragmata;
      "${localDir}/OpenDyslexic".source = ./config/open-dyslexic;
    };
  };
}
