{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfgLSD = config.milkyway.shell.lsd;
  cfgEza = config.milkyway.shell.eza;

  yamlFormat = pkgs.formats.yaml {};
in {
  options.milkyway.shell = {
    eza = milkyway.mkEnableOpt "Better `ls` command";
    lsd = milkyway.mkEnableOpt "Next Gen `ls` command";
  };

  config = mkMerge [
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
          symlink-arrow = "->";
          icons = {when = "never";};
          color = {theme = "custom";};

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
