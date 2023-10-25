{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.hardware.performance-tweaks;
in {
  options.milkyway.hardware.performance-tweaks = with types; {
    enable = mkBoolOpt false "Whether or not to enable common system features.";
    zramSwap = mkEnableOpt "ZRAM swap.";
    cachyos-kernel = mkEnableOpt "Use the Linux_cachyos kernel.";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Supply fitting rules for ananicy-cpp
      environment.systemPackages = [pkgs.ananicy-cpp-rules];

      services = {
        # BPF-based auto-tuning of Linux system parameters
        bpftune.enable = mkDefault true;

        # Automatically tune nice levels
        ananicy = {
          enable = mkDefault true;
          package = pkgs.ananicy-cpp;
        };
      };

      boot = {
        ## A few other kernel tweaks
        kernel.sysctl = {
          "kernel.nmi_watchdog" = 0;
          "kernel.sched_cfs_bandwidth_slice_us" = 3000;
          "net.core.rmem_max" = 2500000;
          "vm.max_map_count" = 16777216;
          "vm.swappiness" = 60;
        };

        # Use the Linux_cachyos kernel
        kernelPackages =
          mkIf (cfg.cachyos-kernel.enable && isNyxEnabled config)
          (mkForce pkgs.linuxPackages_cachyos);
      };

      # Fedora defaults for systemd-oomd
      systemd.oomd = {
        enable = lib.mkForce true; # This is actually the default, anyways...
        enableSystemSlice = mkDefault true;
        enableUserServices = mkDefault true;
      };
    }

    (mkIf cfg.zramSwap.enable {
      # Supply fitting rules for ananicy-cpp
      environment.systemPackages = with pkgs; [
        zram-generator
      ];

      # 90% ZRAM as swap
      zramSwap = mkIf cfg.zramSwap.enable {
        algorithm = "zstd";
        memoryPercent = 90;
        enable = mkDefault true;
      };
    })
  ]);
}
