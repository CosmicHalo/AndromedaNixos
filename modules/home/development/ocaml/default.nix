{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.development.ocaml;
in {
  options.milkyway.development.ocaml = with types; {
    enable = mkEnableOption "Ocaml programming language.";
  };

  config = mkIf cfg.enable {
    milkyway.home.sessionPath = ["$HOME/.opam"];

    home.packages = with pkgs; [
      opam
      ocaml
      dune_3
      ocamlPackages.ocaml-lsp
      ocamlPackages.ocamlformat
    ];
  };
}
