{
  lib,
  config,
  options,
  ...
}:
with lib;
with lib.milkyway; {
  options.milkyway.home = with types; {
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
  };
}
