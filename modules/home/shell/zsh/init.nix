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
    [ -f ~/.config/zsh/p10k.zsh ] && source ~/.config/zsh/p10k.zsh
    [ -f ~/.config/zsh/powerlevel2k.zsh ] && source ~/.config/zsh/powerlevel2k.zsh
    [ -f ~/.config/zsh/p10k.rtx.zsh ] && source ~/.config/zsh/p10k.rtx.zsh
  '';
in {
  options.milkyway.shell.zsh = with types; {
    shellFunctionsExtra =
      mkOpt lines ""
      "Extra shell functions to add.";

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

    zsourceExtra =
      mkOpt lines ''''
      "Commands to be source that shoukld be added to zshrc`.";

    zexportsExtra =
      mkOpt lines ''''
      "Commands to be source that shoukld be added to zshrc`.";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      inherit (cfg) initExtraBeforeCompInit;

      initExtraFirst =
        strings.concatStrings
        [
          (optionalString powerlevelEnabled powerlevelInit)
          cfg.initExtraFirst
        ];

      initExtra =
        strings.concatStrings
        [
          cfg.shellFunctionsExtra
          cfg.zstyleExtra
          cfg.zexportsExtra

          (strings.concatStrings [cfg.zsourceExtra (optionalString powerlevelEnabled powerlevelSource)])

          cfg.initExtra
        ];
    };
  };
}
