{
  lib,
  pkgs,
  flake,
  config,
  ...
}:
with lib;
with flake.lib.milkyway; let
  tomlFormat = pkgs.formats.toml {};
  cfg = config.milkyway.development.rtx;
in {
  options.milkyway.development.rtx = with types; {
    enable = mkEnableOption "RTX";
    package = mkOpt package pkgs.rtx "RTX package to install.";

    settings = mkOpt tomlFormat.type {} ''
      Settings written to {file}`$XDG_CONFIG_HOME/rtx/config.toml`.

      See <https://github.com/jdxcode/rtx#global-config-configrtxconfigtoml>
      for details on supported values.

      ::: {.warning}
      Modifying the `tools` section doesn't make RTX install them.
      You have to manually run `rtx install` to install the tools.
      :::
    '';
  };

  config = mkIf cfg.enable {
    programs.rtx = {
      inherit (cfg) settings;
      enable = true;
    };
  };
}
