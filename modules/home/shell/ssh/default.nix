{
  lib,
  config,
  inputs,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.shell.ssh;

  hostnames =
    (builtins.attrNames (inputs.self.outputs.nixosConfigurations or []))
    ++ (builtins.attrNames (inputs.self.outputs.darwinConfigurations or []));

  matchBlocksOpt = with types;
    submodule {
      options = {
        user =
          mkNullOpt str null
          "Specifies the user to log in as.";
        hostname =
          mkNullOpt str null
          "Specifies the real host name to log into.";
        host =
          mkNullOpt str null ''
            `Host` pattern used by this conditional block.
            See
            {manpage}`ssh_config(5)`
            for `Host` block details.
            This option is ignored if
            {option}`ssh.matchBlocks.*.match`
            if defined.
          ''
          // {example = "*.example.org";};
        match =
          mkNullOpt str null ''
            `Match` block conditions used by this block. See
            {manpage}`ssh_config(5)`
            for `Match` block details.
            This option takes precedence over
            {option}`ssh.matchBlocks.*.host`
            if defined.
          ''
          // {example = "host <hostname> canonical\nhost <hostname> exec \"ping -c1 -q 192.168.17.1\"";};

        port =
          mkNullOpt port null
          "Specifies port number to connect on remote host.";

        forwardAgent = mkBoolOpt false ''
          Whether the connection to the authentication agent (if any)
          will be forwarded to the remote machine.
        '';

        forwardX11 = mkBoolOpt false ''
          Specifies whether X11 connections will be automatically redirected
          over the secure channel and {env}`DISPLAY` set.
        '';

        forwardX11Trusted = mkBoolOpt false ''
          Specifies whether remote X11 clients will have full access to the
          original X11 display.
        '';

        extraOptions =
          mkOpt (attrsOf str) {}
          "Extra configuration options for the host.";
      };
    };
in {
  options.milkyway.shell.ssh = with types; {
    enable = mkEnableOption "SSH";
    ssh-agent = mkEnableOpt "SSH agent";

    forwardAgent = mkBoolOpt true ''
      Forward the authentication agent connection. This can also be
      specified on a per-host basis in the `matchBlocks` option.
    '';

    extraConfig =
      mkLinesOpt ""
      "Extra SSH configuration";

    extraOptionOverrides = mkOpt (attrsOf str) {} ''
      Extra SSH configuration options that take precedence over any
      host specific configuration.
    '';

    matchBlocks =
      mkOpt (either (hm.types.dagOf matchBlocksOpt) attrs) {} ''
        Specify per-host settings. Note, if the order of rules matter
        then use the DAG functions to express the dependencies as
        shown in the example.

        See
        {manpage}`ssh_config(5)`
        for more information.
      ''
      // {
        example = literalExpression ''
          {
            "john.example.com" = {
              hostname = "example.com";
              user = "john";
            };
            foo = lib.hm.dag.entryBefore ["john.example.com"] {
              hostname = "example.com";
              identityFile = "/home/john/.ssh/foo_rsa";
            };
          };
        '';
      };
  };

  config = mkIf cfg.enable {
    services.ssh-agent = cfg.ssh-agent;

    programs.ssh = {
      enable = true;

      matchBlocks =
        cfg.matchBlocks
        // {
          net = {
            forwardAgent = true;
            host = builtins.concatStringsSep " " hostnames;
            remoteForwards = [
              {
                bind.address = ''/%d/.gnupg-sockets/S.gpg-agent'';
                host.address = ''/%d/.gnupg-sockets/S.gpg-agent.extra'';
              }
            ];
          };
        };

      inherit (cfg) forwardAgent extraConfig extraOptionOverrides;
    };
  };
}
