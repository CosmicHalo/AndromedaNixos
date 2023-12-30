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

      z4hPlugins = [
        "ohmyzsh/ohmyzsh"
      ];

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

        #******
        # LIB
        #******

        z4h source ohmyzsh/ohmyzsh/lib/cli.zsh
        z4h source ohmyzsh/ohmyzsh/lib/completion.zsh
        z4h source ohmyzsh/ohmyzsh/lib/correction.zsh
        z4h source ohmyzsh/ohmyzsh/lib/key-bindings.zsh
        z4h source ohmyzsh/ohmyzsh/lib/grep.zsh
        z4h source ohmyzsh/ohmyzsh/lib/misc.zsh
        z4h source ohmyzsh/ohmyzsh/lib/spectrum.zsh
        z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file

        #******
        # LIB
        #******

        z4h load ohmyzsh/ohmyzsh/plugins/brew
        z4h load ohmyzsh/ohmyzsh/plugins/colored-man-pages
        z4h load ohmyzsh/ohmyzsh/plugins/colorize
        z4h load ohmyzsh/ohmyzsh/plugins/command-not-found
        z4h load ohmyzsh/ohmyzsh/plugins/direnv
        z4h load ohmyzsh/ohmyzsh/plugins/dotenv
        z4h load ohmyzsh/ohmyzsh/plugins/emoji
        z4h load ohmyzsh/ohmyzsh/plugins/emoji
        z4h load ohmyzsh/ohmyzsh/plugins/fd
        z4h load ohmyzsh/ohmyzsh/plugins/fzf
        z4h load ohmyzsh/ohmyzsh/plugins/git-extras
        z4h load ohmyzsh/ohmyzsh/plugins/gitfast
        z4h load ohmyzsh/ohmyzsh/plugins/gnu-utils
        z4h load ohmyzsh/ohmyzsh/plugins/magic-enter
        z4h load ohmyzsh/ohmyzsh/plugins/pyenv
        z4h load ohmyzsh/ohmyzsh/plugins/pylint
        z4h load ohmyzsh/ohmyzsh/plugins/ripgrep
        z4h load ohmyzsh/ohmyzsh/plugins/sudo
        z4h load ohmyzsh/ohmyzsh/plugins/z
        z4h load ohmyzsh/ohmyzsh/plugins/zoxide
        z4h load ohmyzsh/ohmyzsh/plugins/zsh-interactive-cd
        z4h load ohmyzsh/ohmyzsh/plugins/zsh-navigation-tools

        # Source Command Not Found
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
        eval "$(${pkgs.z-lua}/bin/z.lua --init zsh enhanced once echo)"

        # run programs that are not in PATH with comma
        command_not_found_handler() {
          ${pkgs.comma}/bin/comma "$@"
        }
      '';
    };
  };
}
