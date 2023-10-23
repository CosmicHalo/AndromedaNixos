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
  options.milkyway.shell.zsh = with types; {
    enable = mkBoolOpt true "Whether to enable zsh shell environement.";
    extraShellAliases = mkOpt (attrsOf (nullOr (either str path))) {} "Extra shell aliases to add.";
  };

  # imports = [
  #   ./init.nix
  # ];

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

      plugins = [
        {
          name = "powerlevel10k";
          file = "powerlevel10k.zsh-theme";
          src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "406ce293f5302fdebca56f8c59ec615743260604";
            sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
          };
        }
      ];

      zplug = {
        enable = true;
        plugins = [
          {name = "zsh-users/zsh-autosuggestions";} # Simple plugin installation
          {name = "zsh-users/zsh-history-substring-search";}
          {
            name = "plugins/git";
            tags = ["as:theme" "from:oh-my-zsh"];
          }
        ];
      };
    };
  };
}
