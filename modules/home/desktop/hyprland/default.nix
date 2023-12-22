{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.desktop.hyprland;
in {
  imports = [
    ./scripts.nix
  ];

  options.milkyway.desktop.hyprland = with types; {
    enable = mkEnableOption "Hyprland Desktop.";
  };

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        __GL_VRR_ALLOWED = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
        WLR_RENDERER_ALLOW_SOFTWARE = "1";

        WLR_RENDERER = "vulkan";
        CLUTTER_BACKEND = "wayland";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
      };
    };

    home.packages = with pkgs; [
      wofi
      waybar
      swww
    ];

    #test later systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      enableNvidiaPatches = false;
      extraConfig = builtins.readFile ./hyprland.conf;
    };

    home.file = {
      #".config/hypr/hyprland.conf".source = ./hyprland.conf;

      ".config/hypr/colors".text = ''
        $background = rgba(1d192bee)
        $foreground = rgba(c3dde7ee)

        $color0 = rgba(1d192bee)
        $color1 = rgba(465EA7ee)
        $color2 = rgba(5A89B6ee)
        $color3 = rgba(6296CAee)
        $color4 = rgba(73B3D4ee)
        $color5 = rgba(7BC7DDee)
        $color6 = rgba(9CB4E3ee)
        $color7 = rgba(c3dde7ee)
        $color8 = rgba(889aa1ee)
        $color9 = rgba(465EA7ee)
        $color10 = rgba(5A89B6ee)
        $color11 = rgba(6296CAee)
        $color12 = rgba(73B3D4ee)
        $color13 = rgba(7BC7DDee)
        $color14 = rgba(9CB4E3ee)
        $color15 = rgba(c3dde7ee)
      '';
    };
  };
}
