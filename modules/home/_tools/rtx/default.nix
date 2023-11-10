{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.tools.rtx;
  tomlFormat = pkgs.formats.toml {};

  defaultTools = {
    tools = {
      node = "18";
    };

    settings = {
      jobs = 16;
      verbose = true;
      asdf_compat = true;
      experimental = true;
    };
  };
in {
  options.milkyway.tools.rtx = with types; {
    enable = mkEnableOption "RTX";
    package = mkOpt package pkgs.rtx "RTX package to install.";

    settings = mkOpt tomlFormat.type defaultTools ''
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
