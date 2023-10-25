{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib) types mkIf mkEnableOption;
  inherit (lib.milkyway) mkOpt mkEnableOpt' enabled;

  cfg = config.milkyway.shell.git;
  inherit (config.milkyway) user;
in {
  options.milkyway.shell.git = with types; {
    enable = mkEnableOption "Git";

    userEmail = mkOpt str user.email "The email to configure git with.";
    userName = mkOpt str user.fullName "The name to configure git with.";

    lfs = mkEnableOpt' "git-lfs.";
    gitui = mkEnableOpt' "gitui.";
    lazygit = mkEnableOpt' "lazygit.";

    signingKey = mkOpt (nullOr str) null "The key ID to sign commits with.";
    signByDefault = mkOpt bool true "Whether to sign commits by default.";
  };

  config = mkIf cfg.enable {
    home.activation.removeExistingGitconfig = inputs.home-manager.lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      rm -f ~/.gitconfig
      rm -rf ~/.config/gh/config.yml
    '';

    home.packages = with pkgs; [
      github-copilot-cli
    ];

    programs = {
      gitui = mkIf cfg.gitui.enable enabled;
      lazygit = mkIf cfg.lazygit.enable enabled;

      gh = {
        enable = true;
        package = pkgs.gh;

        settings = {
          prompt = "enabled";
          git_protocol = "ssh";
        };
      };

      git = {
        inherit (cfg) userName userEmail;

        enable = true;
        attributes = ["*.pdf diff=pdf"];
        ignores = [".DS_Store" ".direnv" "result"];

        # Common
        difftastic.enable = false;
        diff-so-fancy.enable = false;
        delta = {
          enable = true;
          options = {
            diff-so-fancy = true;
            line-numbers = true;
            true-color = "always";
            # features => named groups of settings, used to keep related settings organized
            # features = "";
          };
        };

        #LFS
        lfs = mkIf cfg.lfs.enable {
          enable = true;
          skipSmudge = true;
        };

        signing = {
          inherit (cfg) signByDefault;
          key = cfg.signingKey;
        };

        extraConfig = {
          am.threeWay = true;
          branch = {autoSetupRebase = "always";};
          commit = {verbose = true;};
          core = {whitespace = "trailing-space,space-before-tab";};
          diff = {
            renames = true;
            colorMoved = true;
          };
          gpg.program = "${config.programs.gpg.package}/bin/gpg2";
          init = {defaultBranch = "main";};
          interactive.singleKey = true;
          merge = {
            conflictStyle = "zdiff3";
          };
          pull = {rebase = true;};
          push = {
            autoSetupRemote = true;
            recurseSubmodules = "on-demand";
          };
          rebase = {
            stat = true;
            autoStash = true;
            autoSquash = true;
            updateRefs = true;
          };
          rerere = {
            autoUpdate = true;
            enabled = true;
          };
        };
      };
    };
  };
}
