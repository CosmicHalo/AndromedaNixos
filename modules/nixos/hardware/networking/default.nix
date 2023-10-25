{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.hardware.networking;
in {
  options.milkyway.hardware.networking = with types; {
    enable =
      mkBoolOpt false
      "Whether or not to enable networking support";

    hostName =
      mkOpt str "supernova"
      "The Default Network Hostname";

    hostId =
      mkOpt str "1946258a"
      "The Default Network HostID";

    hosts =
      mkOpt attrs {}
      (mdDoc "An attribute set to merge with `networking.hosts`");

    useDHCP = mkOpt bool false "Whether or not to use DHCP";
    useNetworkd = mkOpt bool false "Whether or not to use systemd-networkd";
    enableWireless = mkOpt bool false "Whether or not to enable wireless networking";
  };

  config = mkIf cfg.enable {
    milkyway.user.extraGroups = ["networkmanager"];

    # Enable Mosh, a replacement for OpenSSH
    programs.mosh.enable = true;

    # Enable bandwidth usage tracking
    services = {
      vnstat.enable = true;
      openntpd.enable = true;
    };

    networking = {
      inherit (cfg) hostId hostName;

      # Enable nftables instead of iptables
      nftables.enable = true;

      useDHCP = mkDefault cfg.useDHCP;
      useNetworkd = mkDefault cfg.useNetworkd;

      hosts =
        {
          "127.0.0.1" = ["local.test"] ++ (cfg.hosts."127.0.0.1" or []);
        }
        // cfg.hosts;

      firewall = {
        allowedTCPPorts = [
          22
          80
          443
          8080
        ];
      };

      # Network Manager
      networkmanager = {
        enable = true;
        unmanaged = ["lo" "docker0" "virbr0"];

        wifi = {
          backend = "iwd";
          powersave = mkDefault false;
        };
      };

      wireless.iwd = mkIf cfg.enableWireless {
        enable = mkDefault true;
        settings = {
          General.AddressRandomization = mkDefault "once";
          General.AddressRandomizationRange = mkDefault "full";
        };
      };
    };

    hardware.wirelessRegulatoryDatabase = mkDefault true;

    # Enable BBR & cake
    boot.kernelModules = ["tcp_bbr"];
    boot.kernel.sysctl = {
      "net.ipv4.tcp_fin_timeout" = 5;
      "net.core.default_qdisc" = "cake";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    # Fixes an issue that normally causes nixos-rebuild to fail.
    # https://github.com/NixOS/nixpkgs/issues/180175
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
