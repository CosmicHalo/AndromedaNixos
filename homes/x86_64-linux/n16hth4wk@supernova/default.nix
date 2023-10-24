{lib, ...}:
with lib.milkyway; {
  home.stateVersion = "23.11";

  milkyway = {
    shell = {
      zsh = enabled;
    };
  };
}
