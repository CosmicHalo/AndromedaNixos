{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.suites.development;
in {
  options.milkyway.suites.development = with types; {
    enable = mkEnableOption "Whether or not to enable common development configuration.";
  };

  config = mkIf cfg.enable {
    milkyway = {
      apps = {
        # IDES
        neovim = enabled;
        vscode = enabled;

        jetbrains = {
          enable = true;
          rider = enabled;
        };

        # programs
        docker = enabled;
        kitty = enabled;
      };

      shell = {
        git = enabled;
        ssh = enabled;
        # starship = enabled;
        zsh = enabled;
      };
    };
  };
}
