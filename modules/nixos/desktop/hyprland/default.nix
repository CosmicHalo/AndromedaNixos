{lib, ...}:
with lib.milkyway; {
  programs.hyprland = {
    enable = true;
  };

  milkyway.home.extraOptions = {
    milkyway.desktop.hyprland = enabled;
    milkyway.programs = {
      dunst = enabled;
      rofi = enabled;
      waybar = enabled;
    };
  };
}
