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
    enable = mkEnableOption "Whether or not to configure OpenSSH support.";

    authorizedKeys =
      mkOpt (listOf str) []
      "The public keys to apply.";
    authorizedKeysFiles =
      mkOpt (listOf str) [inputs.my-ssh-keys.outPath]
      "The public key files to apply.";
  };

  config = mkIf cfg.enable {
    services.openssh.authorizedKeysFiles = cfg.authorizedKeysFiles;
    milkyway.user.extraOptions.openssh.authorizedKeys.keys = cfg.authorizedKeys;
    milkyway.user.extraOptions.openssh.authorizedKeys.keyFiles = cfg.authorizedKeysFiles;

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
