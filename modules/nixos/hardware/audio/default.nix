{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.hardware.audio;
  cfgPipewire = config.milkyway.hardware.audio.pipewire;
  cfgPulseAudio = config.milkyway.hardware.audio.pulseaudio;
in {
  options.milkyway.hardware.audio = with types; {
    enable = mkBoolOpt false "Whether or not to enable audio support.";

    pulseaudio = {
      enable = mkBoolOpt false "Whether or not to enable PulseAudio support.";
      configFile = mkOpt (nullOr path) null "PulseAudio configuration.";
    };

    pipewire = {
      enable = mkBoolOpt false "Whether or not to enable Pipewire support.";
    };

    extra-packages = mkOpt (listOf package) [
      pkgs.qjackctl
      # pkgs.easyeffects
    ] "Additional packages to install.";
  };

  config =
    mkMerge
    [
      {
        # Enable sound
        sound.enable = mkDefault cfg.enable;
        environment.systemPackages = with pkgs; [psmisc];
        milkyway.user.extraGroups = ["audio"];
      }

      /*
       **************
      * PULSE AUDIO *
      **************
      */
      (mkIf cfgPulseAudio.enable {
        security.rtkit.enable = lib.mkForce false;
        services.pipewire.enable = lib.mkForce false;

        hardware.pulseaudio = {
          enable = lib.mkForce true;
          package = pkgs.pulseaudioFull;

          systemWide = true;
          support32Bit = true;
          extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
        };
      })

      /*
       ***********
      * PIPEWIRE *
      ***********
      */
      (mkIf cfgPipewire.enable {
        # Enable the realtime kit
        security.rtkit.enable = true;

        # Disable PulseAudio
        hardware.pulseaudio.enable = mkForce false;

        # Pipewire & wireplumber configuration
        services.pipewire = {
          enable = mkDefault true;
          jack.enable = mkDefault true;
          alsa.enable = mkDefault true;
          systemWide = mkDefault false;
          pulse.enable = mkDefault true;
          alsa.support32Bit = mkDefault true;
          wireplumber.enable = mkDefault true;
        };

        systemd.user.services = {
          pipewire.wantedBy = ["default.target"];
          pipewire-pulse.wantedBy = ["default.target"];
        };

        # Pipewire configuration
        environment = {
          systemPackages = with pkgs;
            [
              pulsemixer
              pavucontrol
            ]
            ++ cfg.extra-packages;

          etc = {
            # Allow pipewire to dynamically adjust the rate sent to the devices based on the playback stream
            "pipewire/pipewire.conf.d/99-allowed-rates.conf".text = builtins.toJSON {
              "context.properties"."default.clock.allowed-rates" = [
                44100
                48000
                88200
                96000
                176400
                192000
              ];
            };
            # If resampling is required, use a higher quality. 15 is overkill and too cpu expensive without any obvious audible advantage
            "pipewire/pipewire-pulse.conf.d/99-resample.conf".text = builtins.toJSON {
              "stream.properties"."resample.quality" = 10;
            };
            "pipewire/client.conf.d/99-resample.conf".text = builtins.toJSON {
              "stream.properties"."resample.quality" = 10;
            };
            "pipewire/client-rt.conf.d/99-resample.conf".text = builtins.toJSON {
              "stream.properties"."resample.quality" = 10;
            };
          };
        };
      })
    ];
}
