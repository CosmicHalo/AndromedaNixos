{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.jetbrains;
in {
  options.milkyway.apps.jetbrains = mkEnableOpt "JetBrains IDEs";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # jetbrains-mono
      jetbrains-toolbox
      jetbrains.idea-ultimate
      jetbrains.jdk
      jetbrains.rider
      # jetbrains.rust-rover
    ];
  };
}
