{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.shell.zsh;
  powerlevelEnabled = cfg.powerlevel10k.enable;

  powerlevelInit = ''
    # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
    # Initialization code that may require console input (password prompts, [y/n]
    # confirmations, etc.) must go above this block; everything else may go below.
    if [[ -r "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh" ]]; then
      source "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh"
    fi
  '';

  powerlevelSource = ''
    [[ -f ~/.config/zsh/p10k/p10k.zsh ]] && source ~/.config/zsh/p10k/p10k.zsh
    [[ -f ~/.config/zsh/p10k/p10k.rtx.zsh ]] && source ~/.config/zsh/p10k/p10k.rtx.zsh
  '';
in {
  options.milkyway.shell.zsh = with types; {
    initExtraFirst =
      mkOpt lines ""
      "Extra commands that should be added to  top zshrc`.";

    initExtraBeforeCompInit =
      mkOpt lines ''''
      "Extra commands that should be added to zshrc` before compinit.";

    initExtra =
      mkOpt lines ""
      "Extra commands that should be added to zshrc`.";

    zstyleExtra =
      mkOpt lines ''''
      "Extra zstyle commands that should be added to zshrc`.";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      initExtraFirst =
        strings.concatStringsSep " "
        [
          (optionalString powerlevelEnabled powerlevelInit)
          cfg.initExtraFirst
        ];

      initExtraBeforeCompInit = strings.concatStringsSep " " [
        (builtins.readFile ./config/zstyle.zsh)
        cfg.initExtraBeforeCompInit
        cfg.zstyleExtra
      ];

      initExtra =
        strings.concatStringsSep " " [
          (builtins.readFile ./config/ziminit.zsh)
          (optionalString powerlevelEnabled powerlevelSource)
          /*
          bash
          */
          ''
            # avoid duplicated entries in PATH
            typeset -U PATH

            # Remove older command from the history if a duplicate is to be added.
            setopt HIST_IGNORE_ALL_DUPS

            # try to correct the spelling of commands
            setopt CORRECT

            # disable C-S/C-Q
            setopt noflowcontrol

            # Customize spelling correction prompt.
            SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

            # Remove path separator from WORDCHARS.
            WORDCHARS=$\{WORDCHARS//[\/]}

            # disable "no matches found" check
            unsetopt nomatch

            # Set editor default keymap to emacs (`-e`) or vi (`-v`)
            bindkey -e

            # edit the current command line in $EDITOR
            bindkey -M vicmd v edit-command-line

            # zsh-history-substring-search
            # historySubstringSearch.{searchUpKey,searchDownKey} does not work with
            # vicmd, this is why we have this here
            bindkey -M vicmd 'k' history-substring-search-up
            bindkey -M vicmd 'j' history-substring-search-down

            # allow ad-hoc scripts to be add to PATH locally
            export PATH="$HOME/.local/bin:$PATH"

            # source contents from ~/.zshrc.d/*.zsh
            for file in "$HOME/.zshrc.d/"*.zsh; do
              [[ -f "$file" ]] && source "$file"
            done
          ''
        ]
        + cfg.initExtra;
    };
  };
}
