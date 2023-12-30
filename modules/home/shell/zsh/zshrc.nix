{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.shell.zsh;

  zshSeperator = "\n#${lib.concatStrings (lib.replicate 100 "-")}\n";
in {
  options.milkyway.shell.zsh = with types; {
    zshOpts =
      mkOpt lines ""
      "Extra options that should be added to zshrc`.";

    zshBindings =
      mkOpt lines ""
      "Extra key bindings that should be added to zshrc`.";

    zshInitExtra =
      mkOpt lines ""
      "Extra source commands that should be added to zshrc`.";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      initExtraFirst = concatStringsSep zshSeperator [
        (builtins.readFile ./config/z4h.zsh)

        # Clone additional Git repositories from GitHub.
        (concatMapStringsSep "\n" (x: "z4h install " + x + " || return") cfg.z4hPlugins)

        ''
          # Install or update core components (fzf, zsh-autosuggestions, etc.) and
          # initialize Zsh. After this point console I/O is unavailable until Zsh
          # is fully initialized. Everything that requires user interaction or can
          # perform network I/O must be done above. Everything else is best done below.
          z4h init || return
        ''
      ];

      initExtra = concatStringsSep zshSeperator [
        cfg.zshOpts
        cfg.zshBindings
        cfg.zshInitExtra

        /*
        zsh
        */
        ''
          # allow ad-hoc scripts to be add to PATH locally
          export PATH="$HOME/.local/bin:$PATH"

          # source contents from ~/.zshrc.d/*.zsh
          if [ -d "$HOME/.zshrc.d" ]; then
            for file in "$HOME/.zshrc.d/"*.zsh; do
              [[ -f "$file" ]] && z4h source "$file"
            done
          fi
        ''
      ];
    };

    # # Compile ZSH config files
    # home.file.".zshrc".text = concatStringsSep zshSeperator [
    #   (builtins.readFile ./config/z4h_init)

    #   # Clone additional Git repositories from GitHub.
    #   (concatMapStringsSep "\n" (x: "z4h install " + x + " || return") cfg.z4hPlugins)

    #   ''
    #     # Install or update core components (fzf, zsh-autosuggestions, etc.) and
    #     # initialize Zsh. After this point console I/O is unavailable until Zsh
    #     # is fully initialized. Everything that requires user interaction or can
    #     # perform network I/O must be done above. Everything else is best done below.
    #     z4h init || return
    #   ''

    #   cfg.zshOpts
    #   cfg.zshBindings
    #   cfg.zshInitExtra

    #   /*
    #   zsh
    #   */
    #   ''
    #     # allow ad-hoc scripts to be add to PATH locally
    #     export PATH="$HOME/.local/bin:$PATH"

    #     # source contents from ~/.zshrc.d/*.zsh
    #     if [ -d "$HOME/.zshrc.d" ]; then
    #       for file in "$HOME/.zshrc.d/"*.zsh; do
    #         [[ -f "$file" ]] && z4h source "$file"
    #       done
    #     fi
    #   ''
    # ];
  };
}
