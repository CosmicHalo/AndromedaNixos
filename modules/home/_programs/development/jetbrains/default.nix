{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.jetbrains;

  mkInclude = pkgName: defaultPackage: {
    enable = mkEnableOption pkgName;
    package = mkPackageOpt defaultPackage pkgName;
  };

  mkOptional = name:
    lib.optional
    cfg.${name}.enable
    cfg.${name}.package;
in {
  options.milkyway.programs.jetbrains = {
    enable = mkEnableOption "JetBrains IDEs";

    rider = mkInclude "Rider" pkgs.jetbrains.rider;
    rust-rover = mkInclude "Rust Rover" pkgs.jetbrains.rust-rover;
    toolbox = mkInclude "JetBrains Toolbox" pkgs.jetbrains-toolbox;
    idea-ultimate = mkInclude "IntelliJ IDEA Ultimate" pkgs.jetbrains.idea-ultimate;
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.toolbox.enable {
      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "jetbrains-toolbox"
        ];
    })

    {
      home.packages = with pkgs;
        [
          jetbrains-mono
        ]
        ++ mkOptional "rider"
        ++ mkOptional "toolbox"
        ++ mkOptional "rust-rover"
        ++ mkOptional "idea-ultimate";
    }
  ]);
}
