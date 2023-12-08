{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.milkyway.services.vscode-server;
in {
  options.milkyway.services.vscode-server = {
    enable = mkEnableOption "vscode-server";
  };

  config = mkIf cfg.enable {
    # services.vscode-server.enable = true;
  };
}
