{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.milkyway.shell.ssh;
  hostnames = builtins.attrNames inputs.self.outputs.nixosConfigurations;
in {
  options.milkyway.shell.ssh = {
    enable = mkEnableOption "SSH";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      extraConfig = ''
        XAuthLocation ${pkgs.xorg.xauth}/bin/xauth
      '';

      matchBlocks = {
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
    };
  };
}
