{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.user;

  home-directory =
    if cfg.name == null
    then null
    else "/Users/${cfg.name}";
in {
  imports = [
    ./home.nix
  ];

  options.milkyway.user = with types; {
    name =
      mkOpt str "jlecoq@dnanexus.com"
      "The name to use for the user account.";

    home =
      mkOpt (types.nullOr types.str) home-directory
      "The user's home directory.";

    fullName =
      mkOpt
      str "Jacob LeCoq" "The full name of the user.";
    email =
      mkOpt
      str "jlecoq@dnanexus.com" "The email of the user.";
    shell =
      mkOpt
      (enum ["zsh" "fish" "nushell"]) "zsh" "The shell to use for the user.";
    uid =
      mkOpt (types.nullOr types.int) 501
      "The uid for the user account.";
    extraOptions =
      mkOpt attrs {}
      (mdDoc "Extra options passed to `users.users.<name>`.");
  };

  config = {
    programs.${cfg.shell}.enable = true;
    nix.settings.trusted-users = [cfg.name];

    users.users.${cfg.name} =
      {
        inherit (cfg) name uid;

        home = mkForce cfg.home;
        description = mkForce cfg.name;
        shell = mkForce pkgs.${cfg.shell};
      }
      // cfg.extraOptions;

    milkyway.home.file = {
      ".profile".text = ''
        # The default file limit is far too low and throws an error when rebuilding the system.
        # See the original with: ulimit -Sa
        ulimit -n 4096
      '';
    };
  };
}
