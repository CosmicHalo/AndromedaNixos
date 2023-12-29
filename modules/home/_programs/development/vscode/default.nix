{
  lib,
  pkgs,
  config,
  isDarwin,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.vscode;

  # vscode-fhs breaks on darwin
  defaultPackage =
    if isDarwin
    then pkgs.vscode
    else pkgs.vscode-fhs;
in {
  options.milkyway.programs.vscode = {
    enable = mkEnableOption "vscode";

    package =
      mkOpt types.package defaultPackage
      "Package to use for vscode";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      inherit (cfg) package;

      enableUpdateCheck = true;
      mutableExtensionsDir = true;
      enableExtensionUpdateCheck = true;
    };
  };
}
