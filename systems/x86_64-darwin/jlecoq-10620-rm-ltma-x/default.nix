{
  lib,
  inputs,
  ...
}:
with lib.milkyway; {
  environment = {
    darwinConfig = "${inputs.self.outPath}";

    systemPath = [
      "/usr/bin"
      "/opt/homebrew/bin"
    ];
  };

  nix.configureBuildUsers = true;

  milkyway = {
    nix = let
      builder-ip = "82.165.211.45";
    in {
      extraOptions = ''
        builders = ssh://root@${builder-ip} x86_64-linux;
      '';

      distributedBuilds = {
        enable = true;
        buildMachines = [
          {
            maxJobs = 1;
            speedFactor = 2;
            protocol = "ssh-ng";
            mandatoryFeatures = [];
            hostName = "${builder-ip}";
            systems = ["x86_64-linux" "x86_64-darwin"];
            supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          }
        ];
      };
    };

    homebrew = {
      enable = true;

      onActivation = {
        upgrade = true;
        autoUpdate = true;
      };

      extraBrews = [
        # "llvm"
        "pkgxdev/made/pkgx"
      ];

      extraCasks = [
        "bitwarden"
      ];
    };

    security = {
      gpg = enabled;
    };

    services = {
      openssh = enabled;
    };

    system = {
      fonts = enabled;
      input = enabled;
      interface = enabled;
    };
  };

  system = {
    stateVersion = 4;
    checks.verifyNixPath = true;
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    };
  };
}
