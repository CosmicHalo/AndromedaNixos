{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.nix;
  # cfgChaotic = cfg.chaotic;
  cfgTools = cfg.tools;
in {
  options.milkyway.nix = {
    extraOptions =
      mkLinesOpt ""
      "Additional text appended to nix.conf.";

    chaotic = {
      enable = mkEnablOption "chaotic-nyx";
      cache = mkEnableOpt "chaotic-nyx cache";
      overlay = mkEnableOpt "chaotic-nyx overlay";
    };

    tools = {
      alejandra = mkEnableOpt' "alejandra formatter";
      direnv = mkEnableOpt' "Direnv";
      statix = mkEnableOpt' "statix";
      nil = mkEnableOpt' "nil";

      cachix = mkEnableOpt "cachix";
      deadnix = mkEnableOpt "deadnix";
      flake = mkEnableOpt "Snowfallorg Flake";
    };
  };

  config = {
    home.packages = with pkgs;
      [
        nvd
        nixpkgs-fmt
      ]
      ++ lib.optional cfgTools.nil.enable nil
      ++ lib.optional cfgTools.cachix.enable cachix
      ++ lib.optional cfgTools.direnv.enable direnv
      ++ lib.optional cfgTools.statix.enable statix
      ++ lib.optional cfgTools.deadnix.enable deadnix
      ++ lib.optional cfgTools.flake.enable snowfallorg.flake
      ++ lib.optional cfgTools.alejandra.enable milkyway.alejandra;

    /*
     ******
    * NYX *
    ******
    */
    # chaotic.nyx = mkIf cfgChaotic.enable {
    #   cache.enable = cfgChaotic.cache.enable;
    #   overlay.enable = cfgChaotic.overlay.enable;
    # };

    nix = {
      inherit (cfg) extraOptions;
    };

    /*
     ***********
    * PROGRAMS *
    ***********
    */
    programs = {
      nix-index.enable = true;
      home-manager.enable = true;

      direnv = mkIf cfgTools.direnv.enable {
        enable = true;
        nix-direnv = enabled;
        enableBashIntegration = true; # see note on other shells below
      };
    };
  };
}
