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

  milkyway = {
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
