{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.hardware.common;
in {
  options.milkyway.hardware.common = with types; {
    enable = mkBoolOpt true "Whether or not to enable common hardware support.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      duf
      libva-utils # vainfo
      usbutils # lsusb - work with USB devices
      vulkan-tools # vulkaninfo
    ];

    # Microcode and firmware updates
    hardware = {
      enableRedistributableFirmware = mkDefault true;

      cpu = {
        amd.updateMicrocode = mkDefault true;
        intel.updateMicrocode = mkDefault true;
      };

      opengl = {
        enable = mkDefault true;
        driSupport = mkDefault true;
        driSupport32Bit = mkDefault true;

        extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
        ];

        extraPackages32 = with pkgs.pkgsi686Linux; [
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
    };
  };
}
