{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.hardware.amd;
in {
  options.milkyway.hardware.amd = with types; {
    enable = mkBoolOpt false "Whether or not to enable amd hardware support.";
  };

  config = mkIf cfg.enable {
    boot = {
      # Disable k10temp as it conflicts with zenpower
      blacklistedKernelModules = [
        "k10temp"
      ];

      kernelModules = ["kvm-amd"];

      # Enable zenpower
      extraModulePackages = with config.boot.kernelPackages; [zenpower];
    };

    # AMD device
    services = {
      hardware.bolt.enable = false;
      xserver.videoDrivers = ["amdgpu"];
    };

    # RADV video decode & general usage
    environment.variables = {
      AMD_VULKAN_ICD = "RADV";
    };

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
