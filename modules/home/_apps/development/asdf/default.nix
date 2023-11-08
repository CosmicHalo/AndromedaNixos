{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.asdf;
in {
  options.milkyway.apps.asdf = with types; {
    enable = mkEnableOption "ASDF-VM";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      asdf-vm
      gawk
    ];
  };
}
