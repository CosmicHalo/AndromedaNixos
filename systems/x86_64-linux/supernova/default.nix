{
  lib,
  inputs,
  ...
}:
with lib;
with lib.milkyway; {
  imports = with inputs; [
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate
    nixos-hardware.nixosModules.common-gpu-nvidia-disable

    ./hardware.nix
  ];

  ### MISC    ###############################################

  system.stateVersion = mkDefault "23.11";
  nixpkgs.hostPlatform = mkDefault "x86_64-linux";

  ### CONFIG    #############################################

  milkyway = {
    ### HARDWARE    ###############################################

    hardware = {
      amd = enabled;
      bluetooth = enabled;
      btrfs = enabled;

      audio = {
        enable = true;
        pipewire = disabled;
      };

      # Hostname & hostId for ZFS
      networking = {
        enable = true;
        hostName = "supernova";
      };

      # performance-tweaks = {
      #   enable = true;
      #   zramSwap = enabled;
      #   cachyos-kernel = enabled;
      # };
    };

    ### SECURITY    ###############################################

    ### SERVICES    ###############################################

    services = {
      btrfs-maintenance = enabled;
      openssh = enabled;
    };

    ### SYSTEM    ###############################################
    system = {
      boot.systemd-boot = enabled;
    };
  };
}
