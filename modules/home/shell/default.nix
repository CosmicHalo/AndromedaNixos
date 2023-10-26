{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) types mkIf;
  inherit (lib.milkyway) hasPackage mkOpt;

  hasExa = hasPackage "eza" config.home.packages;
in {
  options.milkyway.shell = with types; {
    commonShellAliases = mkOpt (attrsOf str) {} "Common shell aliases";
  };

  config = {
    home.packages = with pkgs; [
      autorandr
      bat
      btop
      curl
      eza
      fzf
      fd
      gh
      git
      killall
      lsd
      micro
      nvd
      ripgrep
      rsync
      screen
      sysz
      tldr
      ugrep
      wget
      xorg.xrandr
    ];

    milkyway.shell.commonShellAliases = {
      # Nix
      "run" = "nix run nixpkgs#";
      "use" = "nix shell nixpkgs#";

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
      "fastfetch" = "fastfetch -l nixos";
      "fgrep" = "fgrep --color=auto";
      "g" = "git";
      "gitlog" = "git log --oneline --graph --decorate --all";
      "grep" = "rg";
      "hms" = "home-manager switch";
      "ip" = "ip --color=auto";
      "jctl" = "journalctl -p 3 -xb";

      exa = mkIf hasExa "eza";
      ls = mkIf hasExa "eza -a --color=always --group-directories-first --icons";
      ll = mkIf hasExa "ls -ll"; # long format
      la = mkIf hasExa "ls -la"; # long format
      lt = mkIf hasExa "ls -T"; # tree listing
      "l." = mkIf hasExa "ll .*"; # show only dotfiles

      "md" = "mkdir -p";
      "micro" = "micro -colorscheme geany -autosu true -mkparents true";
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
