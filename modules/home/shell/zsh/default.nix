{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.shell.zsh;
  inherit (config.milkyway.shell) commonShellAliases;
in {
  imports = [
    ./init.nix
    ./plugins.nix
  ];

  options.milkyway.shell.zsh = with types; {
    enable = mkBoolOpt false "Whether to enable zsh shell environement.";
    profileExtra = mkOpt lines "" "Extra commands that should be added to {file}`.zprofile`.";
    extraShellAliases = mkOpt (attrsOf (nullOr (either str path))) {} "Extra shell aliases to add.";
  };

  config = mkIf cfg.enable {
    programs = {
      skim.enable = false;
      zoxide.enableZshIntegration = true;

      atuin = {
        enable = true;

        enableBashIntegration = true;
        enableNushellIntegration = true;

        settings = {
          auto_sync = true;
          sync_frequency = "1h";
        };
      };
    };

    programs.zsh = {
      inherit (cfg) profileExtra;

      enable = true;
      enableCompletion = true;
      enableAutosuggestions = false;
      syntaxHighlighting.enable = true;

      shellAliases =
        commonShellAliases
        // cfg.extraShellAliases
        // {
          # General useful things & theming
          "cls" = "clear";
          "gcommit" = "git commit -m";
          "glcone" = "git clone";
          "gpr" = "git pull --rebase";
          "gpull" = "git pull";
          "gpush" = "git push";
          "say" = "${pkgs.toilet}/bin/toilet -f pagga";
          "su" = "sudo su -";
          "tarnow" = "tar acf ";
          "untar" = "tar zxvf ";
        };
    };
  };
}
