{
  lib,
  flake,
  config,
  ...
}:
with lib;
with flake.lib.milkyway; let
  cfg = config.milkyway.shell.zsh;
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
      inherit (cfg) initExtraFirst initExtraBeforeCompInit;

      initExtra =
        strings.concatStrings
        [
          cfg.shellFunctionsExtra
          cfg.zstyleExtra
          cfg.zexportsExtra
          cfg.zsourceExtra
          cfg.initExtra
        ];
    };
  };
}
