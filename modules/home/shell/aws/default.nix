{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.shell.aws;
in {
  options.milkyway.shell.aws = with types; {
    enable = mkEnableOption "AWS shell";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      awscli2
    ];

    home.file.".aws/config".text = ''
      [default]
      region = us-east-1

      [profile bootstrap]
      sso_start_url = https://d-9067696184.awsapps.com/start
      sso_region = us-east-1
      sso_role_name = bootstrap
      sso_account_id = 111111111111

      [profile Vdev_Developer-263799606133-Platform_vDevelopment]
      sso_start_url = https://d-9067696184.awsapps.com/start
      sso_region = us-east-1
      sso_account_id = 263799606133
      sso_role_name = Vdev_Developer
      region = us-east-1
    '';

    milkyway.shell.zsh.extraShellAliases = {
      "aws-refresh" = "AWS_PROFILE=bootstrap aws sso login";
      "aws-profiles" = "aws configure list-profiles";
    };
  };
}
