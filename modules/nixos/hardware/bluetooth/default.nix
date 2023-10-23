{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfgFmt = pkgs.formats.ini {};

  cfg = config.milkyway.hardware.bluetooth;
in {
  options.milkyway.hardware.bluetooth = with types; {
    enable = mkBoolOpt false "Whether or not to enable bluetooth support.";
    package = mkOpt package pkgs.bluez "The bluetooth package to use.";

    input = mkOpt cfgFmt.type {} "Set configuration for the input service (/etc/bluetooth/input.conf).";
    settings = mkOpt cfgFmt.type {} "Set configuration for system-wide bluetooth (/etc/bluetooth/main.conf).";
    network = mkOpt cfgFmt.type {} "Set configuration for the network service (/etc/bluetooth/network.conf).";

    disabledPlugins = mkOpt (listOf str) [] "List of plugins to disable.";
  };

  config = mkIf cfg.enable {
    # Enable bluetooth but don't start it automatically on boot
    hardware.bluetooth = {
      enable = mkDefault true;
      inherit (cfg) disabledPlugins package input settings network;
    };

    boot.kernelModules = [
      "bluetooth"
      "hidp"
    ];
  };
}
