{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib;
with lib.andromeda; let
  cfg = config.andromeda.system.configuration;
in {
  /*
   ************************
  * COMMON CONFIGURATIONS *
  ************************
  */

  config = mkIf cfg.enable {
    # Default applications
    environment.systemPackages = with pkgs; [
      autorandr
      bat
      btop
      curl
      # eza
      inputs.eza.packages.${pkgs.system}.default
      fzf
      fd
      gh
      git
      killall
      micro
      neovim
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

    programs = {
      # Fix (read: workaround) an issue with Sqlite
      command-not-found.enable = mkDefault false;
      nix-index-database.comma.enable = mkDefault true;
    };
  };
}
