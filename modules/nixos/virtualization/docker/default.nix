{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.milkyway.virtualisation.docker;

  inherit (lib.milkyway) mkEnableOpt;
in {
  options.milkyway.virtualisation.docker = mkEnableOpt "Docker";

  config = mkIf cfg.enable {
    milkyway.user.extraGroups = ["docker"];

    environment.systemPackages = with pkgs; [
      docker-compose
    ];

    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
