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

    package =
      mkOpt types.package pkgs.discord
      "The Discord package to use.";

    canary.enable =
      mkBoolOpt false
      "Whether or not to enable Discord Canary.";
    native.enable =
      mkBoolOpt false
      "Whether or not to enable the native version of Discord.";
  };

  config = mkIf cfg.enable {
    home.packages =
      lib.optional cfg.enable cfg.package
      ++ lib.optional cfg.native.enable pkgs.discord
      ++ lib.optional cfg.canary.enable pkgs.discord-canary;
  };
}
