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

    envExtra =
      mkOpt lines ""
      "Extra environment variables that should be added to {file}`.zshenv`.";

    profileExtra =
      mkOpt lines ""
      "Extra commands that should be added to {file}`.zprofile`.";

    extraShellAliases =
      mkOpt (attrsOf (nullOr (either str path))) {}
      "Extra shell aliases to add.";
  };

  config = mkIf cfg.enable {
    # Set ZSH Powerlevel10k theme
    xdg.configFile."zsh/p10k" = {
      source = ./p10k;
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
    };

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
      # ".zimrc".source = ./env/zimrc.zsh;
      ".zshrc.zwc".source = compileZshConfig ".zshrc";
      ".zshenv.zwc".source = compileZshConfig ".zshenv";
      ".zprofile.zwc".source = compileZshConfig ".zprofile";
    };

    programs.zsh = {
      enable = true;
      autocd = true;
      defaultKeymap = "viins";

      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;

      history = {
        share = true;
        ignoreDups = true;
        ignoreSpace = true;
        expireDuplicatesFirst = true;
      };

      historySubstringSearch = {
        enable = true;
        searchUpKey = ["$terminfo[kcuu1]"];
        searchDownKey = ["$terminfo[kcud1]"];
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

      envExtra = (builtins.readFile ./env/zshenv.zsh) + cfg.envExtra;

      profileExtra =
        ''
          # Source .profile
          [[ -e ~/.profile ]] && emulate sh -c '. ~/.profile'
        ''
        + lib.optionalString pkgs.stdenv.isDarwin ''
          # Source nix-daemon profile since macOS updates can remove it from /etc/zshrc
          # https://github.com/NixOS/nix/issues/3616
          if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
            source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
          fi

          # Set the soft ulimit to something sensible
          # https://developer.apple.com/forums/thread/735798
          ulimit -Sn 524288
        ''
        + cfg.profileExtra;
    };
  };
}
