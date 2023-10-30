{pkgs, ...}: {
  imports = [
    ./keymaps.nix
    ./options.nix
  ];

  config = {
    luaLoader.enable = true;
    package = pkgs.neovim-unwrapped;
  };
}
