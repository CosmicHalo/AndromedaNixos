{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) types mkIf mkDefault mkEnableOption;
  inherit (lib.milkyway) mkOpt;

  cfg = config.milkyway.user;
  is-darwin = pkgs.stdenv.isDarwin;

  home-directory =
    if cfg.name == null
    then null
    else if is-darwin
    then "/Users/${cfg.name}"
    else "/home/${cfg.name}";
in {
  imports = [
    ./home.nix
  ];

  options.milkyway.user = {
    enable = mkEnableOption "User account.";
    name =
      mkOpt (types.nullOr types.str) config.andromeda.user.name
      "The user account.";
    fullName =
      mkOpt types.str "Jacob LeCoq"
      "The full name of the user.";
    email =
      mkOpt types.str "lecoqjacob@gmail.com"
      "The email of the user.";
    homeDirectory =
      mkOpt (types.nullOr types.str) home-directory
      "The user's home directory.";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.name != null;
        message = "milkyway.user.name must be set";
      }
      {
        assertion = cfg.homeDirectory != null;
        message = "milkyway.user.home must be set";
      }
    ];

    home = {
      username = mkDefault cfg.name;
      homeDirectory = mkDefault cfg.homeDirectory;
    };

    systemd.user.startServices = "sd-switch";
  };
}
