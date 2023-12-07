{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.services.tailscale;
in {
  options.milkyway.services.tailscale = {
    enable = mkEnableOption "Tailscale";

    autoconnect = {
      enable = mkBoolOpt false "Whether or not to enable automatic connection to Tailscale";
      key = mkOpt str "" "The authentication key to use";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.autoconnect.enable -> cfg.autoconnect.key != "";
        message = "milkyway.services.tailscale.autoconnect.key must be set";
      }
    ];

    environment.systemPackages = with pkgs; [
      ktailctl
      tailscale-systray
    ];

    # Enable the Tailscale service
    services.tailscale = enabled;
  };
}
