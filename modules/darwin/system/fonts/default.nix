{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.system.fonts;
in {
  options.milkyway.system.fonts = with types; {
    enable = mkBoolOpt false "Whether or not to manage fonts.";
    fonts = mkOpt (listOf package) [] "Custom font packages to install.";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.input-fonts.acceptLicense = true;

    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    fonts = {
      fontDir = enabled;

      fonts = with pkgs;
        [
          # Fonts
          noto-fonts
          noto-fonts
          noto-fonts-cjk
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-emoji
          open-dyslexic

          # icon fonts
          material-symbols
        ]
        ++ cfg.fonts;
    };
  };
}
