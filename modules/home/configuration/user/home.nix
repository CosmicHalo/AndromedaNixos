{
  lib,
  config,
  options,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.home;
in {
  options.milkyway.home = with types; {
    stateVersion =
      mkOpt types.str "23.11"
      "The state version to use for the user account.";
    sessionPath =
      mkListOpt types.str ["$HOME/.local/bin"]
      "The user's session path.";
    sessionVariables =
      mkOpt types.attrs {}
      "The user's session variables.";

    # file =
    #   mkOpt attrs config.home.file
    #   (mdDoc "A set of files to be managed by home-manager's `home.file`.");

    configFile =
      mkOpt attrs {}
      (mdDoc "A set of files to be managed by home-manager's `xdg.configFile`.");
  };

  config = {
    xdg.enable = true;
    # home.file = mkAliasDefinitions options.milkyway.home.file;
    xdg.configFile = mkAliasDefinitions options.milkyway.home.configFile;

    home = {
      inherit (cfg) sessionPath sessionVariables stateVersion;
    };
  };
}
