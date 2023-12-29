{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.milkyway.shell.eza;
  yamlFormat = pkgs.formats.yaml {};

  inherit (lib) mkIf;
  inherit (lib.milkyway) mkEnableOpt;
in {
  options.milkyway.shell.lsd = mkEnableOpt "Better `ls` command";

  config = mkIf cfg.enable {
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
  };
}
