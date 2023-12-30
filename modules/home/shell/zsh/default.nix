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
    ./env.zsh.nix
    ./plugins.zsh.nix
    ./zshrc.nix
  ];

  options.milkyway.shell.zsh = with types; {
    enable = mkEnableOption "ZShell";

    extraShellAliases =
      mkOpt (attrsOf (nullOr (either str path))) {}
      "Extra shell aliases to add.";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      # zproof.enable = false;
      defaultKeymap = "emacs";
      enableCompletion = true;
      enableVteIntegration = true;
      enableAutosuggestions = true;

      historySubstringSearch = {
        enable = false;
      };

      # syntaxHighlighting = {
      #   enable = false;
      #   highlighters = ["main" "brackets" "cursor"];
      # };

      history = {
        share = true;
        ignoreDups = true;
        ignoreSpace = true;
        expireDuplicatesFirst = true;
      };

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

    programs = {
      # Atuin - shell history
      atuin = {
        enable = true;
        settings = {
          auto_sync = true;
          sync_frequency = "1h";
        };
      };
    };

    # Compile ZSH config files
    home.file = let
      compileZshConfig = filename:
        pkgs.runCommand filename
        {
          name = "${filename}-zwc";
          nativeBuildInputs = [pkgs.zsh];
        } ''
          cp "${config.home.file.${filename}.source}" "${filename}"
          zsh -c 'zcompile "${filename}"'
          cp "${filename}.zwc" "$out"
        '';
    in {
      ".p10k.zwc".source = compileZshConfig ".p10k.zsh";
      ".zshrc.zwc".source = compileZshConfig ".zshrc";
      ".zshenv.zwc".source = compileZshConfig ".zshenv";
      ".zprofile.zwc".source = compileZshConfig ".zprofile";
    };
  };
}
