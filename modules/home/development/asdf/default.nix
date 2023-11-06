{
  lib,
  pkgs,
  flake,
  config,
  ...
}:
with lib;
with flake.lib.milkyway; let
  cfg = config.milkyway.development.asdf;
in {
  options.milkyway.development.asdf = with types; {
    enable = mkEnableOption "ASDF-VM";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      asdf-vm
      gawk
    ];
  };
}
