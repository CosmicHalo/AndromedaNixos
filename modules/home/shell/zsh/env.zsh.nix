{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.shell.zsh;
in {
  options.milkyway.shell.zsh = with types; {
    loginExtra =
      mkOpt lines ""
      "Extra commands that should be added to {file}`.zlogin`.";

    envExtra =
      mkOpt lines ""
      "Extra commands that should be added to {file}`.zshenv`.";

    profileExtra =
      mkOpt lines ""
      "Extra commands that should be added to {file}`.zprofile`.";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      envExtra =
        (builtins.readFile ./config/zshenv)
        + cfg.envExtra;

      loginExtra =
        ''${pkgs.figlet}/bin/figlet -f banner "Andromeda Terminal"''
        + cfg.loginExtra;

      profileExtra =
        ''
          # Source .profile
          [[ -e ~/.profile ]] && emulate sh -c '. ~/.profile'
        ''
        + lib.optionalString pkgs.stdenv.isDarwin ''
          # Source nix-daemon profile since macOS updates can remove it from /etc/zshrc
          # https://github.com/NixOS/nix/issues/3616
          if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
            source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
          fi

          # Set the soft ulimit to something sensible
          # https://developer.apple.com/forums/thread/735798
          ulimit -Sn 524288
        ''
        + cfg.profileExtra;
    };
  };
}
