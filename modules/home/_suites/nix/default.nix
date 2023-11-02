{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.suites.nix;
in {
  options.milkyway.suites.nix = with types; {
    enable =
      mkBoolOpt false
      "Whether or not to enable common nix configuration.";
  };

  config = mkIf cfg.enable {
    milkyway = {
      nix = {
        tools = {
          alejandra = enabled;
          cachix = enabled;
          deadnix = enabled;
          direnv = enabled;
          statix = enabled;
        };
      };
    };
  };
}
