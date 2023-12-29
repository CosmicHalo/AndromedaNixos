{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.milkyway) mkEnableOpt;

  cfg = config.milkyway.shell.exa;
in {
  options.milkyway.shell.exa = mkEnableOpt "Better `ls` command";

  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;

      git = true;
      icons = true;
      enableAliases = true;

      extraOptions = [
        "--color=always"
        "--group-directories-first"
        "--icons"
      ];
    };
  };
}
