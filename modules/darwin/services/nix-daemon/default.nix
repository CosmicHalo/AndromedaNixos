{
  lib,
  config,
  ...
}: let
  inherit (lib) types mkIf;
  inherit (lib.milkyway) mkOpt enabled;

  cfg = config.milkyway.services.nix-daemon;
in {
  options.milkyway.services.nix-daemon = {
    enable = mkOpt types.bool true "Whether to enable the Nix daemon.";
  };

  config = mkIf cfg.enable {
    services.nix-daemon = enabled;
  };
}
