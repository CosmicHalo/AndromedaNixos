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

    # Allow Tailscale devices to connect
    networking = {
      firewall = {
        # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
        checkReversePath = "loose";
        allowedUDPPorts = [config.services.tailscale.port];
        trustedInterfaces = [config.services.tailscale.interfaceName];
      };

      networkmanager.unmanaged = ["tailscale0"];
    };

    # Enable the Tailscale service
    services.tailscale = enabled;

    systemd = {
      services.tailscale-autoconnect = mkIf cfg.autoconnect.enable {
        description = "Automatic connection to Tailscale";

        # Make sure tailscale is running before trying to connect to tailscale
        wantedBy = ["multi-user.target"];
        after = ["network-pre.target" "tailscale.service"];
        wants = ["network-pre.target" "tailscale.service"];

        # Set this service as a oneshot job
        serviceConfig.Type = "oneshot";

        # Have the job run this shell script
        script = with pkgs; ''
          # Wait for tailscaled to settle
          sleep 2

          # Check if we are already authenticated to tailscale
          status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
          if [ $status = "Running" ]; then # if so, then do nothing
            exit 0
          fi

          # Otherwise authenticate with tailscale
          ${tailscale}/bin/tailscale up -authkey "${cfg.autoconnect.key}"
        '';
      };
    };
  };
}
