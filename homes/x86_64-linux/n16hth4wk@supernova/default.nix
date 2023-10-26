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

    suites = {
      desktop = enabled;
      development = enabled;
      nix = enabled;
    };

    apps = {
      bitwarden = enabled;
    };
  };
}
