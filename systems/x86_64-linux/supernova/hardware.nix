{
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "bcache"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44cd32f0-0979-4aa9-94f5-70cb8ddd709e";
    fsType = "btrfs";
    options = ["subvol=rootfs"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/44cd32f0-0979-4aa9-94f5-70cb8ddd709e";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/44cd32f0-0979-4aa9-94f5-70cb8ddd709e";
    fsType = "btrfs";
    options = ["subvol=home"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1859-7F80";
    fsType = "vfat";
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  # networking.interfaces.enp16s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp21s0u1u2u1c2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
