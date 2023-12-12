{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.milkyway.virtualisation.podman;

  inherit (lib.milkyway) mkEnableOpt;
in {
  options.milkyway.virtualisation.podman = mkEnableOpt "Podman";

  config = mkIf cfg.enable {
    milkyway.user.extraGroups = ["docker"];

    environment.systemPackages = with pkgs; [
      podman-compose
    ];

    virtualisation = {
      podman = {
        enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        # dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    virtualisation.oci-containers.backend = "podman";
    virtualisation.oci-containers.containers = {
      container-name = {
        image = "container-image";
        autoStart = true;
        ports = ["127.0.0.1:1234:1234"];
      };
    };
  };
}
