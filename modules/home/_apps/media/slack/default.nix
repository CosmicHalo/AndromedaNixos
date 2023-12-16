{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.slack;
in {
  options.milkyway.apps.slack = with types; {
    enable = mkBoolOpt false "Whether or not to enable slack.";

    package =
      mkOpt types.package pkgs.slack
      "The slack package to use.";

    canary.enable =
      mkBoolOpt false
      "Whether or not to enable slack Canary.";
    native.enable =
      mkBoolOpt false
      "Whether or not to enable the native version of slack.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package

      slack-cli
      slack-term
    ];
  };
}
