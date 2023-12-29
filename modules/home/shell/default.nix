{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) types mkIf mkMerge;
  inherit (lib.milkyway) hasPackage mkOpt mkEnableOpt enabled disabled;

  cfgLSD = config.milkyway.shell.lsd;
  cfgEza = config.milkyway.shell.eza;
  yamlFormat = pkgs.formats.yaml {};

  hasLSD = hasPackage "lsd" config.home.packages;
  hasEza = hasPackage "eza" config.home.packages;
in {
  options.milkyway.shell = with types; {
    eza = mkEnableOpt "Better `ls` command";
    lsd = mkEnableOpt "Next Gen `ls` command";
    commonShellAliases = mkOpt (attrsOf str) {} "Common shell aliases";
  };

  config = mkMerge [
    {
      # Default to using lsd
      milkyway.shell.lsd = enabled;
      milkyway.shell.eza = disabled;

      programs = {
        fzf = {
          enable = true;
          historyWidgetOptions = ["--sort"];
          fileWidgetOptions = ["--preview 'head {}'"];
        };
      };

      home.packages = with pkgs; [
        autorandr
        bat
        btop
        conky
        curl
        fd
        gh
        git
        guake
        killall
        lsd
        micro
        nvd
        ripgrep
        rsync
        safe-rm
        screen
        skim
        stow
        sysz
        tldr
        ugrep
        wget
        xorg.xrandr

        milkyway.inshellisense
      ];

      milkyway.shell.commonShellAliases = {
        # Nix
        "run" = "nix run nixpkgs#";
        "use" = "nix shell nixpkgs#";
        "hmb" = "home-manager build";
        "hms" = "home-manager switch";

        # Other
        ".." = "cd ..";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        "....." = "cd ../../../../";
        "......" = "cd ../../../../../";

        "bat" = "bat --style header --style snip --style changes";
        "cat" = "bat";
        "dd" = "dd progress=status";
        "df" = "duf";
        "diffnix" = "nvd diff $(sh -c 'ls -d1v /nix/var/nix/profiles/system-*-link|tail -n 2')";
        "dir" = "dir --color=auto";
        "egrep" = "egrep --color=auto";
        "exa" = mkIf hasEza "eza";
        "fastfetch" = "fastfetch -l nixos";
        "fgrep" = "fgrep --color=auto";
        "g" = "git";
        "gitlog" = "git log --oneline --graph --decorate --all";
        "grep" = "rg";
        "ip" = "ip --color=auto";
        "jctl" = "journalctl -p 3 -xb";

        ls =
          if hasLSD
          then "${pkgs.lsd}/bin/lsd -gF --sort=extension --color=auto"
          else if hasEza
          then "${pkgs.eza}/bin/eza"
          else "ls -F --color=auto";

        "md" = "mkdir -p";
        "micro" = "micro -colorscheme geany -autosu true -mkparents true";
        "psmem" = "ps auxf | sort -nr -k 4";
        "psmem10" = "ps auxf | sort -nr -k 4 | head -1";
        "rs" = "sudo systemctl";
        "us" = "systemctl --user";
        "vdir" = "vdir --color=auto";
        "vim" = "nvim";
        "wget" = "wget -c";
        "x" = "xargs";
        "xo" = "xdg-open";
      };
    }

    (mkIf cfgEza.enable {
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
    })

    (mkIf cfgLSD.enable {
      programs.lsd = {
        enable = true;
        enableAliases = true;

        settings = {
          header = true;
          indicators = true;
          symlink-arrow = "->";

          color = {
            theme = "custom";
          };

          icons = {
            when = "auto";
            theme = "fancy";
          };

          blocks = [
            "permission"
            "user"
            "group"
            "date"
            "git"
            "name"
          ];
        };
      };

      home.file.".config/lsd/colors.yaml".source = yamlFormat.generate "colors.yaml" {
        user = "dark_yellow";
        group = "dark_yellow";
        permission = {
          read = "dark_yellow";
          write = "dark_magenta";
          exec = "dark_red";
          exec-sticky = "dark_blue";
          no-access = "red";
          octal = "dark_cyan";
          acl = "dark_cyan";
          context = "dark_cyan";
        };
        date = {
          hour-old = "dark_cyan";
          day-old = "dark_cyan";
          older = "dark_cyan";
        };
        size = {
          none = "dark_green";
          small = "dark_green";
          medium = "dark_green";
          large = "dark_green";
        };
        inode = {
          valid = "dark_magenta";
          invalid = "red";
        };
        links = {
          valid = "dark_blue";
          invalid = "dark_red";
        };
        tree-edge = "dark_cyan";
        git-status = {
          default = "dark_cyan";
          unmodified = "dark_cyan";
          ignored = "dark_cyan";
          new-in-index = "dark_green";
          new-in-workdir = "dark_green";
          typechange = "dark_yellow";
          deleted = "dark_red";
          renamed = "dark_green";
          modified = "dark_yellow";
          conflicted = "dark_red";
        };
      };
    })
  ];
}
