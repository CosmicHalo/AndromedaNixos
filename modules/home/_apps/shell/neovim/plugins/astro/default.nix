_: {
  imports = [
    {_module.args.nvimPath = "nvim/lua/plugins/astro";}
    ./core.nix
    ./lsp.nix
    ./ui.nix
  ];
}
