{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.user;

  defaultIconFileName = "nighthawk.png";
  defaultIcon = pkgs.stdenvNoCC.mkDerivation {
    name = "default-icon";
    src = ./. + "/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = ''
      cp $src $out
    '';

    passthru = {fileName = defaultIconFileName;};
  };

  propagatedIcon =
    pkgs.runCommandNoCC "propagated-icon"
    {passthru = {inherit (cfg.icon) fileName;};}
    ''
      local target="$out/share/milkyway-icons/user/${cfg.name}"
      mkdir -p "$target"

      cp ${cfg.icon} "$target/${cfg.icon.fileName}"
    '';
in {
  imports = [
    ./home.nix
  ];

  options.milkyway.user = with types; {
    name =
      mkOpt str "n16hth4wk"
      "The name to use for the user account.";
    fullName =
      mkOpt str "Jacob LeCoq"
      "The full name of the user.";
    email =
      mkOpt str "lecoqjacob@gmail.com"
      "The email of the user.";

    initialHashedPassword =
      mkOpt str ""
      "The initial password to use when the user is first created.";
    shell =
      mkOpt (enum ["zsh" "fish" "nushell"]) "zsh"
      "The shell to use for the user.";
    icon =
      mkOpt (nullOr package) defaultIcon
      "The profile picture to use for the user.";

    extraGroups =
      mkOpt (listOf str) []
      "Groups for the user to be assigned.";
    extraOptions =
      mkOpt attrs {}
      (mdDoc "Extra options passed to `users.users.<name>`.");
  };

  config = {
    programs.${cfg.shell}.enable = true;
    environment.systemPackages = with pkgs; [
      cowsay
      lolcat
      fortune
      propagatedIcon
    ];

    users.users.${cfg.name} =
      {
        inherit (cfg) name extraGroups initialHashedPassword;

        # Arbitrary user ID to use for the user. Since I only
        # have a single user on my machines this won't ever collide.
        # However, if you add multiple users you'll need to change this
        # so each user has their own unique uid (or leave it out for the
        # system to select).
        uid = 1000;

        isNormalUser = true;
        shell = pkgs.${cfg.shell};

        group = "users";
        home = "/home/${cfg.name}";
      }
      // cfg.extraOptions;
  };
}
