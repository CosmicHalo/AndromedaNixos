{
  lib,
  pkgs,
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

  services.xserver.enable = true;
  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  programs.hyprland = {
    enable = true;
  };

  ### MISC    ###############################################

  system.stateVersion = mkDefault "23.11";
  nixpkgs.hostPlatform = mkDefault "x86_64-linux";

  environment.systemPackages = with pkgs; [
    sqlite
  ];

  ### CONFIG    #############################################

  milkyway = {
    ### DESKTOP    ###############################################

    desktop = {
      kde = enabled;
    };

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

      performance-tweaks = {
        enable = true;
        zramSwap = enabled;
        cachyos-kernel = enabled;
      };
    };

    ### SECURITY    ###############################################

    security = {
      acme = enabled;
      gpg = enabled;
      keyring = enabled;
    };

    ### SERVICES    ###############################################

    services = {
      btrfs-maintenance = enabled;
      openssh = enabled;
    };

    ### SYSTEM    ###############################################
    system = {
      boot.systemd-boot = enabled;
      fonts = enabled;
    };
  };
}
