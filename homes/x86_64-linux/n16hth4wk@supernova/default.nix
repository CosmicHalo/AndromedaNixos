{lib, ...}:
with lib.milkyway; {
  imports = [
    ./fonts.nix
    ./zsh.nix
  ];

  home.stateVersion = "23.11";

  milkyway = {
    user = enabled;
    fonts = enabled;

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
      floorp = enabled;
    };
  };
}
