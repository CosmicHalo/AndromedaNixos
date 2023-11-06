{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.homebrew;
in {
  options.milkyway.homebrew = with types; {
    enable = mkEnableOption "Homebrew";
    brewPrefix = mkOpt str "/usr/local/bin" "Homebrew prefix.";

    onActivation = {
      upgrade = mkBoolOpt true "Upgrade homebrew";
      autoUpdate = mkBoolOpt true "Auto update homebrew";
      cleanup = mkOpt (enum ["none" "uninstall" "zap"]) "none" "Homebrew cleanup mode";
    };

    taps = mkOpt (listOf str) [
      "homebrew/cask"
      "homebrew/services"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
    ] "Homebrew taps";

    extraBrews = mkOpt (listOf str) [] "Homebrew formulae";
    extraCasks = mkOpt (listOf str) [] "Homebrew cask formulae";

    nix-homebrew = {
      enable =
        mkBoolOpt true
        "Whether to enable installation of `Homebrew` via `nix`.";

      # User owning the Homebrew prefix
      user =
        mkOpt str config.milkyway.user.name
        "User owning the Homebrew prefix";

      # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
      enableRosetta =
        mkBoolOpt pkgs.stdenv.hostPlatform.isAarch64
        "Enable Homebrew for Rosetta 2";

      mutableTaps = mkBoolOpt false ''
        Whether to allow imperative management of taps.

        When enabled, taps can be managed via `brew tap` and
        `brew update`.

        When disabled, the auto-update functionality is also
        automatically disabled with `HOMEBREW_NO_AUTO_UPDATE=1`.
      '';
      autoMigrate = mkBoolOpt true ''
        Whether to allow nix-homebrew to automatically migrate existing Homebrew installations.

        When enabled, the activation script will automatically delete
        Homebrew repositories while keeping installed packages.
      '';
    };
  };

  config = mkIf cfg.enable {
    homebrew = {
      inherit (cfg) brewPrefix taps onActivation;
      enable = true;

      brews = cfg.extraBrews;
      casks = cfg.extraCasks;
    };

    nix-homebrew = mkIf cfg.nix-homebrew.enable {
      # inherit mutableTaps;
      inherit (cfg.nix-homebrew) user autoMigrate enableRosetta;
      enable = true;

      # Optional: Declarative tap management
      # taps = {
      #   "homebrew/homebrew-core" = inputs.homebrew-core;
      #   "homebrew/homebrew-cask" = inputs.homebrew-cask;
      # };
    };
  };
}
