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
    enable =
      mkBoolOpt false
      "Whether or not to enable common development configuration.";
  };

  config = mkIf cfg.enable {
    milkyway = {
      apps = {
        # IDES
        vscode = enabled;
        jetbrains = enabled;

        kitty = {
          enable = true;
          font = {
            size = 11;
            name = "OpenDyslexic";
          };
        };
      };

      security = {
        gpg = {
          enable = true;
          gpg-agent = enabled;
        };
      };

      shell = {
        git = enabled;
        neovim = enabled;
        ssh = enabled;
        # starship = enabled;
        zsh = enabled;
      };
    };
  };
}
