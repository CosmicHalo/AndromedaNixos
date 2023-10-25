{lib, ...}:
with lib.milkyway; {
  imports = [
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
