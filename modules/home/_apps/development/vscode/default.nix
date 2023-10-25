{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.vscode;
in {
  options.milkyway.apps.vscode = mkEnableOpt "vscode";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vscode-fhs
    ];
  };
}
