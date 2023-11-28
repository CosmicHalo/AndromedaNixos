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

  ### MISC    ###############################################

  system.stateVersion = mkDefault "23.11";
  nixpkgs.hostPlatform = mkDefault "x86_64-linux";

  ### CONFIG    #############################################

  programs.nix-ld.enable = true;
  environment.systemPackages = with pkgs; [
    sqlite
    python3
  ];

  milkyway = {
    nix = let
      builder-ip = "82.165.211.45";
    in {
      extraOptions = ''
        builders = ssh://root@${builder-ip} x86_64-linux;
      '';

      distributedBuilds = {
        enable = true;
        buildMachines = [
          {
            maxJobs = 1;
            speedFactor = 2;
            protocol = "ssh-ng";
            mandatoryFeatures = [];
            hostName = "${builder-ip}";
            systems = ["x86_64-linux" "x86_64-darwin"];
            supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          }
        ];
      };
    };

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
        pipewire = enabled;
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
      vscode-server = enabled;
    };

    ### SYSTEM    ###############################################
    system = {
      boot.systemd-boot = enabled;
      fonts = enabled;
    };
  };
}
