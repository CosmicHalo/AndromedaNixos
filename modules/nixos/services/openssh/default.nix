{
  lib,
  config,
  host ? "",
  inputs ? {},
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.services.openssh;

  # This is a hold-over from an earlier Andromeda Lib version which used
  # the specialArg `name` to provide the host name.
  name = host;

  other-hosts =
    lib.filterAttrs
    (key: host:
      key != name && (host.config.milkyway.user.name or null) != null)
    ((inputs.self.nixosConfigurations or {}) // (inputs.self.darwinConfigurations or {}));
in {
  options.milkyway.services.openssh = with types; {
    enable = mkBoolOpt false "Whether or not to configure OpenSSH support.";

    ports =
      mkOpt (listOf port) [2222]
      "The port to listen on (in addition to 22).";

    authorizedKeys =
      mkOpt (listOf str) []
      "The public keys to apply.";

    authorizedKeyFiles =
      mkOpt (listOf path) [inputs.my-ssh-keys.outPath]
      "The public key files to apply.";
  };

  config = mkIf cfg.enable {
    # Enable Mosh, a replacement for OpenSSH
    programs.mosh.enable = true;

    services.openssh = {
      enable = true;
      ports = [22] ++ cfg.ports;

      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = true;
      };
    };

    milkyway.user.extraOptions.openssh.authorizedKeys.keys = cfg.authorizedKeys;
    milkyway.user.extraOptions.openssh.authorizedKeys.keyFiles = cfg.authorizedKeyFiles;

    andromeda.home.extraOptions = {
      programs.zsh.shellAliases =
        foldl
        (aliases: system:
          aliases
          // {
            "ssh-${system}" = "ssh ${system} -t tmux a";
          })
        {}
        (builtins.attrNames other-hosts);
    };
  };
}
