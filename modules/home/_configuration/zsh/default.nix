{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.configurations.zsh;
in {
  options.milkyway.configurations.zsh = mkEnableOpt "Shared ZSH configuration";

  config = mkIf cfg.enable {
    home.sessionVariables = {
      ENHANCD_COMMAND = "ecd";
    };

    home.packages = with pkgs; [
      z-lua
      zimfw
    ];

    milkyway.shell.zsh = {
      enable = true;

      z4hPlugins = ["ohmyzsh/ohmyzsh"];

      zshOpts = ''
        # Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.

        setopt glob_dots     # no special treatment for file names with a leading dot
        # setopt no_auto_menu  # require an extra TAB press to open the completion menu
      '';

      zshBindings = ''
        # Define key bindings.
        z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H
        z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

        z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
        z4h bindkey redo Alt+/             # redo the last undone command line change

        z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
        z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
        z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
        z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

        z4h bindkey z4h-eof Ctrl+D
        setopt ignore_eof
      '';

      zshInitExtra = ''
        # Export environment variables.
        export GPG_TTY=$TTY

        # Source additional local files if they exist.
        z4h source ~/.env.zsh

        # Source Command Not Found
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

        eval "$(${pkgs.z-lua}/bin/z.lua --init zsh enhanced once echo)"

        # run programs that are not in PATH with comma
        command_not_found_handler() {
          ${pkgs.comma}/bin/comma "$@"
        }
      '';

      # zplug = {
      #   enable = true;

      #   plugins = [
      #     "b4b4r07/enhancd"
      #   ];

      #   theme-plugins = [
      #     "romkatv/powerlevel10k, depth:1"
      #   ];

      #   oh-my-zsh-plugins = [
      #     "command-not-found, defer:2"
      #     "git-extras, defer:2"
      #     "gitfast, defer:2"
      #     "github, defer:2"
      #     "git, defer:2"
      #     "rbw, defer:2"
      #     "ripgrep, defer:2"
      #     "sudo, defer:2"
      #     "zoxide, defer:2"
      #   ];
      # };
    };
  };
}
