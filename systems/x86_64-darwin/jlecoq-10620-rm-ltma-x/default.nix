{
  lib,
  inputs,
  ...
}:
with lib.milkyway; {
  environment.systemPath = [
    "/usr/bin"
    "/opt/homebrew/bin"
  ];

  environment.darwinConfig = "/nix/store/d7sadiks4c16pyiq6fxk5ynmzwhh9cyh-source";

  milkyway = {
    # user.home = "nebula";

    homebrew = {
      enable = true;
      extraBrews = [
        "llvm"
        "pkgxdev/made/pkgx"
      ];
    };

    #   desktop.addons = {
    #     skhd = enabled;
    #   };

    #   security = {
    #     gpg = enabled;
    #   };

    #   system = {
    #     fonts = enabled;
    #     input = enabled;
    #     interface = enabled;
    #   };
  };

  system = {
    stateVersion = 4;
    checks.verifyNixPath = true;
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock

      # other macOS's defaults configuration.
      # ......
    };
  };
}
