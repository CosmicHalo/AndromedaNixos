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

  services.xrdp.enable = true;
  services.xrdp.openFirewall = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";

  ### CONFIG    #############################################

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
      envfs = enabled;
      flatpak = enabled;
      openssh = enabled;
      tailscale = enabled;
      btrfs-maintenance = enabled;
      # vscode-server = enabled;g
    };

    ### SYSTEM    ###############################################
    system = {
      boot.systemd-boot = enabled;
      fonts = enabled;
    };

    ### VIRTUALIZATION    ###############################################
    virtualisation = {
      docker = enabled;
      # podman = enabled;
    };
  };
}
