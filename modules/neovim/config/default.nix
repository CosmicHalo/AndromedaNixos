{pkgs, ...}: {
  imports = [
    ./autocmds.nix
    ./keymaps.nix
    ./options.nix
  ];

  config = {
    viAlias = true;
    vimAlias = true;
    luaLoader.enable = true;

    package = pkgs.neovim-unwrapped;

    plugins = {
      nix.enable = true;
    };
  };
}
