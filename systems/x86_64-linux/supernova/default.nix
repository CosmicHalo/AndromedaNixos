{
  lib,
  inputs,
  ...
}:
with lib;
with lib.andromeda; {
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ### CONFIG    #############################################

  andromeda = {
    ### HARDWARE    ###############################################

    ### SECURITY    ###############################################
    ### SERVICES    ###############################################

    ### SYSTEM    ###############################################
    system = {
      boot.systemd-boot = enabled;
    };
  };

  # snowfallorg.user = {
  #   "n16hth4wk" = {
  #     create = true;
  #     admin = true;
  #     home.config = {
  #       snowfallorg.user = {
  #         enable = true;
  #         name = "n16hth4wk";
  #       };
  #     };
  #   };
  # };
}
