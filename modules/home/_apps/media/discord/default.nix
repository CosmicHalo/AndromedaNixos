{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.discord;
in {
  options.milkyway.apps.discord = with types; {
    enable = mkBoolOpt false "Whether or not to enable Discord.";
    package = mkOpt types.package pkgs.discord-krisp "The Discord package to use.";

    canary.enable = mkBoolOpt false "Whether or not to enable Discord Canary.";
    native.enable = mkBoolOpt false "Whether or not to enable the native version of Discord.";

    chromium.enable =
      mkBoolOpt false
      "Whether or not to enable the Chromium version of Discord.";

    firefox.enable =
      mkBoolOpt false
      "Whether or not to enable the Firefox version of Discord.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        discordo
        betterdiscordctl
        discord-gamesdk
      ]
      ++ lib.optional cfg.enable cfg.package
      ++ lib.optional cfg.canary.enable pkgs.discord-canary
      ++ lib.optional cfg.chromium.enable pkgs.milkyway.discord-chromium
      ++ lib.optional cfg.firefox.enable pkgs.milkyway.discord-firefox
      ++ lib.optional cfg.native.enable pkgs.discord;
  };
}
