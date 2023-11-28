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
    powerlevel10k = mkEnableOpt' "powerlevel10k";

    profileExtra =
      mkOpt lines ""
      "Extra commands that should be added to {file}`.zprofile`.";
    extraShellAliases =
      mkOpt (attrsOf (nullOr (either str path))) {}
      "Extra shell aliases to add.";
  };

  config = mkIf cfg.enable {
    # Set ZSH Powerlevel10k theme
    xdg.configFile."zsh" = {
      source = ./config;
      recursive = true;
    };

    programs = {
      atuin = {
        enable = true;

        enableBashIntegration = true;
        enableNushellIntegration = true;

        settings = {
          auto_sync = true;
          sync_frequency = "1h";
        };
      };

      skim.enable = false;

      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };

    programs.zsh = {
      inherit (cfg) profileExtra;

      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;

      shellAliases =
        mapAttrs (_n: v: lib.mkForce v) commonShellAliases
        // mapAttrs (_n: v: lib.mkForce v) cfg.extraShellAliases
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
