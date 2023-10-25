{
  lib,
  inputs,
  ...
}:
with lib.milkyway; {
  imports = [
    inputs.chaotic.homeManagerModules.default
    ./zsh.nix
  ];

  home.stateVersion = "23.11";

  milkyway = {
    /*
     *******
    * user *
    *******
    */
    user = enabled;

    /*
     ******
    * nix *
    ******
    */
    nix = {
      home-manager = enabled;

      tools = {
        alejandra = enabled;
        cachix = enabled;
        deadnix = enabled;
        direnv = enabled;
        statix = enabled;
      };
    };

    suites = {
      development = enabled;
    };
  };
}
