{lib, ...}:
with lib.milkyway; {
  imports = [
    ./zsh.nix
  ];

  home.stateVersion = "23.11";

  milkyway = {
    #*********
    #* User
    #*********
    user = enabled;

    #*********
    #* Suites
    #*********
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
