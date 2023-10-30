{
  lib,
  pkgs,
  config,
  ...
}: {
  home.sessionVariables = {
    ENHANCD_COMMAND = "ecd";
  };

  milkyway = {
    shell.zsh = {
      enable = true;

      initExtraBeforeCompInit = ''
        # search history based on what's typed in the prompt
        autoload -U history-search-end
        zle -N history-beginning-search-backward-end history-search-end
        zle -N history-beginning-search-forward-end history-search-end
        bindkey "^[OA" history-beginning-search-backward-end
        bindkey "^[OB" history-beginning-search-forward-end
        bindkey "\e[3~" delete-char

        ZSH_AUTOSUGGEST_USE_ASYNC='true'
        ZSH_AUTOSUGGEST_MANUAL_REBIND='true'
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE='20'
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
      '';

      zstyleExtra = ''
        # case insensitive tab completion
        zstyle ':completion:*' completer _complete _ignored _approximate
        zstyle ':completion:*' list-colors '\'
        zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' menu select
        zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
        zstyle ':completion:*' verbose true
        _comp_options+=(globdots)
      '';

      zsourceExtra = ''
        # Source Command Not Found
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

        # Enable the auto-suggestions plugin
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

        # Enable the fast-syntax-highlighting plugin
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

        # zsh-history-substring-search
        source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

        ${lib.optionalString config.services.gpg-agent.enable ''
          gnupg_path=$(ls $XDG_RUNTIME_DIR/gnupg)
          export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/$gnupg_path/S.gpg-agent.ssh"
        ''}

        # run programs that are not in PATH with comma
        command_not_found_handler() {
          ${pkgs.comma}/bin/comma "$@"
        }

        ${pkgs.toilet}/bin/toilet -f future "Milky Way" --metal

        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';

      zexportsExtra = ''
        # Fix an issue with tmux.
        export KEYTIMEOUT=1

        export LC_CTYPE=en_US.UTF-8
        export LC_ALL=en_US.UTF-8
        export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
      '';

      shellFunctionsExtra = '''';

      zplug = {
        enable = true;

        plugins = [
          "b4b4r07/enhancd"
        ];

        theme-plugins = [
          "romkatv/powerlevel10k, depth:1"
        ];

        oh-my-zsh-plugins = [
          "command-not-found, defer:2"
          "git-extras, defer:2"
          "gitfast, defer:2"
          "github, defer:2"
          # "gpg-agent"
          "git, defer:2"
          "rbw, defer:2"
          "ripgrep"
          "sudo"
          "zoxide, defer:2"
        ];
      };
    };
  };
}
