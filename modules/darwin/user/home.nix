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
    useGlobalPkgs =
      mkBoolOpt true
      "Whether to use global packages with home-manager.";
    useUserPackages =
      mkBoolOpt true
      "Whether to use global packages with home-manager.";

    modules =
      mkOpt (listOf path) []
      "Modules to import into home-manager.";

    file =
      mkOpt attrs config.andromeda.home.file
      (mdDoc "A set of files to be managed by home-manager's `home.file`.");

    configFile =
      mkOpt attrs config.andromeda.home.configFile
      (mdDoc "A set of files to be managed by home-manager's `xdg.configFile`.");

    extraOptions =
      mkOpt attrs config.andromeda.home.extraOptions
      "Options to pass directly to home-manager.";
  };

  config = {
    milkyway.home.extraOptions = {
      xdg.enable = true;
      home.file = mkAliasDefinitions options.milkyway.home.file;
      xdg.configFile = mkAliasDefinitions options.milkyway.home.configFile;
    };

    andromeda.home.extraOptions =
      mkAliasDefinitions options.milkyway.home.extraOptions;

    home-manager = {
      inherit (cfg) useGlobalPkgs useUserPackages;
    };
  };
}
