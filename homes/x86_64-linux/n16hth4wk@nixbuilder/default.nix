{
  lib,
  pkgs,
  config,
  ...
}:
with lib.milkyway; {
  milkyway = {
    user = enabled;

    #*********
    #* Suites
    #*********
    suites = {
      nix = enabled;
    };

    #*********
    #* Apps
    #*********
    apps = {
      tmux = enabled;
      neovim = enabled;
    };

    shell.zsh = {
      enable = true;

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
      '';

      zexportsExtra = ''
        # Fix an issue with tmux.
        export KEYTIMEOUT=1

        export LC_CTYPE=en_US.UTF-8
        export LC_ALL=en_US.UTF-8
        export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
      '';

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

    #*********
    #* System
    #*********
    shell = {
      git = {
        enable = true;
        signingKey = "C505 1E8B 06AC 1776 6875  1B60 93AF DAD0 10B3 CB8D";
      };

      ssh = {
        enable = true;
        ssh-agent = enabled;
      };
    };

    fonts = {
      enable = true;
      extraFonts = [
        # nerdfonts
        (pkgs.nerdfonts.override {
          fonts = [
            "FiraCode"
            "FiraMono"
            "Hack"
            "UbuntuMono"
          ];
        })
      ];
    };
  };
}
