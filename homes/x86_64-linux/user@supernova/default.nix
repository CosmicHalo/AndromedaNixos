{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim
    firefox
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.shellAliases = {
    vimdiff = "nvim -d";
  };

  home.stateVersion = "23.11";
}
