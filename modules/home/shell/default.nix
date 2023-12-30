{
  lib,
  pkgs,
  config,
  ...
}: let
  hasLSD = hasPackage "lsd" config.home.packages;
  hasEza = hasPackage "eza" config.home.packages;

  inherit (lib) types mkIf;
  inherit (lib.milkyway) hasPackage mkOpt mkEnableOpt enabled disabled;
in {
  options.milkyway.shell = with types; {
    eza = mkEnableOpt "Better `ls` command";
    lsd = mkEnableOpt "Next Gen `ls` command";
    commonShellAliases = mkOpt (attrsOf str) {} "Common shell aliases";
  };

  config = {
    # Default to using lsd
    milkyway.shell.lsd = enabled;
    milkyway.shell.eza = disabled;

    programs = {
      fzf = {
        enable = true;
        historyWidgetOptions = ["--sort"];
        fileWidgetOptions = ["--preview 'head {}'"];
      };
    };

    home.packages = with pkgs; [
      autorandr
      bat
      btop
      conky
      curl
      fd
      gh
      git
      guake
      killall
      lsd
      micro
      nvd
      ripgrep
      rsync
      safe-rm
      screen
      skim
      stow
      sysz
      tldr
      ugrep
      wget
      xorg.xrandr

      milkyway.inshellisense
    ];

    milkyway.shell.commonShellAliases = {
      # Nix
      "run" = "nix run nixpkgs#";
      "use" = "nix shell nixpkgs#";
      "hmb" = "home-manager build";
      "hms" = "home-manager switch";

      # Other
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
      "......" = "cd ../../../../../";

      "bat" = "bat --style header --style snip --style changes";
      "cat" = "bat";
      "dd" = "dd progress=status";
      "df" = "duf";
      "diffnix" = "nvd diff $(sh -c 'ls -d1v /nix/var/nix/profiles/system-*-link|tail -n 2')";
      "dir" = "dir --color=auto";
      "egrep" = "egrep --color=auto";
      "exa" = mkIf hasEza "eza";
      "fastfetch" = "fastfetch -l nixos";
      "fgrep" = "fgrep --color=auto";
      "g" = "git";
      "gitlog" = "git log --oneline --graph --decorate --all";
      "grep" = "rg";
      "ip" = "ip --color=auto";
      "jctl" = "journalctl -p 3 -xb";

      ls =
        if hasLSD
        then "${pkgs.lsd}/bin/lsd -gF --sort=extension --color=auto"
        else if hasEza
        then "${pkgs.eza}/bin/eza"
        else "ls -F --color=auto";

      ll =
        if hasLSD
        then "${pkgs.lsd}/bin/lsd -gFlh --sort=extension --color=auto"
        else if hasEza
        then "${pkgs.eza}/bin/eza -l"
        else "ls -Flh --color=auto";

      "md" = "mkdir -p";
      "micro" = "micro -colorscheme geany -autosu true -mkparents true";
      "nix" = "noglob nix";
      "psmem" = "ps auxf | sort -nr -k 4";
      "psmem10" = "ps auxf | sort -nr -k 4 | head -1";
      "rs" = "sudo systemctl";
      "us" = "systemctl --user";
      "vdir" = "vdir --color=auto";
      "vim" = "nvim";
      "wget" = "wget -c";
      "x" = "xargs";
      "xo" = "xdg-open";
    };
  };
}
