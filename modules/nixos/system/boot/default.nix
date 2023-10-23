{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.snowfall.module; let
  cfg = config.andromeda.system.boot;

  cfgQuiet = cfg.quietboot;
  cfgLanza = cfg.lanzaboote;
  cfgSystemd = cfg.systemd-boot;

  activateSecureBoot = cfgSystemd.enable && !cfgLanza.enable;
  activateLanzaboote = cfgLanza.enable && !cfgSystemd.enable;
in {
  options.andromeda.system.boot = with types; {
    quietboot.enable = mkEnableOption "Quietboot.";
    lanzaboote.enable = mkEnableOption "Lanzaboote.";
    systemd-boot.enable = mkEnableOption "systemd-boot.";

    # plymouth = {
    #   enable = mkBoolOpt true "Enable Plymouth";
    #   theme = mkOpt str "catppuccin-mocha" "Plymouth theme";

    #   extraConfig = mkOpt lines "" "Extra plymouth configuration";

    #   additionThemePackages = mkOpt (listOf package) [
    #     (pkgs.andromeda.catppuccin-plymouth.override {variant = "mocha";})
    #   ] "Extra theme packages for plymouth.";
    # };

    tmp = {
      tmpfsSize = mkOpt str "50%" "Size of tmpfs";
      useTmpfs = mkBoolOpt false "Use tmpfs for /tmp";
    };
  };

  config =
    mkMerge
    [
      {
        boot = {
          loader = {
            efi.canTouchEfiVariables = true;
            generationsDir.copyKernels = true;
          };

          # Make use of the systemd initrd
          initrd = {
            verbose = mkDefault false;
            systemd.strip = mkDefault true;
            systemd.enable = mkDefault true;
          };

          kernelParams = mkDefault [
            "iommu=full"
            "preempt=full"
            "mitigations=off"
            "rootflags=noatime"
            "page_alloc.shuffle=1"
            "acpi_backlight=native"
            "processor.max_cstate=5"
            "usbcore.autosuspend=-1"
            "rd.systemd.show_status=auto"
          ];

          # Enables Plymouth with the bgrt theme (UEFI splash screen)
          # plymouth = mkIf cfg.plymouth.enable {
          #   enable = true;

          #   inherit (cfg.plymouth) theme extraConfig;
          #   themePackages = cfg.plymouth.additionThemePackages;
          # };

          tmp = {
            inherit (cfg.tmp) useTmpfs tmpfsSize;
            # Clean /tmp on boot if not using tmpfs
            cleanOnBoot = mkDefault (!config.boot.tmp.useTmpfs);
          };
        };
      }

      /*
       *************************
      * CONFIGURE SYSTEMD-BOOT *
      *************************
      */
      (mkIf activateSecureBoot {
        boot.loader.systemd-boot = {
          editor = false;
          enable = true;
          consoleMode = "max";
          configurationLimit = 10;
        };
      })

      /*
       ***********************
      * CONFIGURE LANZABOOTE *
      ***********************
      */

      (mkIf activateLanzaboote {
        # boot.lanzaboote = mkIf activateLanzaboote {
        #   enable = true;
        #   pkiBundle = "/etc/secureboot";
        # };

        # Configure Lanzaboote
        environment.systemPackages = [pkgs.sbctl];
      })

      /*
      ##########################
      # Configure Quietboot
      ##########################
      */
      (mkIf cfgQuiet.enable {
        boot = {
          consoleLogLevel = 0;
          initrd.verbose = false;

          kernelParams = [
            "quiet"
            "acpi_call"
            "loglevel=3"
            "udev.log_level=3"
            "rd.udev.log_level=3"
            "systemd.show_status=auto"
            "vt.global_cursor_default=0"
          ];
        };
      })
    ];
}
