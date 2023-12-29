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

    milkyway.programs.starship = enabled;

    milkyway.shell.zsh = {
      enable = true;

      zstyleExtra = ''
        zstyle ':completion:*' completer _complete _ignored _approximate
        zstyle ':completion:*' list-colors '\'
        zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' menu select
        zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
        zstyle ':completion:*' verbose true
        _comp_options+=(globdots)
      '';

      initExtra = ''
        # Source Command Not Found
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

        # Enable the auto-suggestions plugin
        # source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

        # Enable the fast-syntax-highlighting plugin
        # source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

        # zsh-history-substring-search
        # source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

        # run programs that are not in PATH with comma
        command_not_found_handler() {
          ${pkgs.comma}/bin/comma "$@"
        }

        ${pkgs.toilet}/bin/toilet -f future "Milky Way" --metal

        ${lib.optionalString config.services.gpg-agent.enable ''
          gnupg_path=$(ls $XDG_RUNTIME_DIR/gnupg)
          export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/$gnupg_path/S.gpg-agent.ssh"
        ''}
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
