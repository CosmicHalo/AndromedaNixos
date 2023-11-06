{
  lib,
  pkgs,
  flake,
  config,
  ...
}:
with lib;
with flake.lib.milkyway; let
  cfg = config.milkyway.development.rust;
in {
  options.milkyway.development.rust = with types; {
    enable = mkEnableOption "Rust programming language.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fenix.default.toolchain

      gcc
      libiconv
      pkg-config
      coreutils-full
      rust-analyzer-nightly
    ];
  };
}
