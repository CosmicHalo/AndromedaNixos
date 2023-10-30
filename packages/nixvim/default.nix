{
  lib,
  pkgs,
  inputs,
  neovim-config ? {},
  neovim-settings ? {},
  ...
}: let
  inherit (pkgs.nixvim-lib) helpers;
  raw-modules = lib.andromeda.fs.get-default-nix-files-recursive (lib.andromeda.fs.get-file "/modules/neovim");

  wrapped-modules =
    builtins.map
    (
      raw-module: args: let
        result = import raw-module (args
          // {
            # NOTE: nixvim doesn't allow for these to be customized so we must work around the
            # module system here...
            inherit lib pkgs helpers inputs;
          });
      in
        result
        // {
          _file = raw-module;
        }
    )
    raw-modules;

  raw-neovim = pkgs.nixvim.makeNixvimWithModule {
    module = {
      imports = wrapped-modules;

      config = lib.mkMerge [
        {
          _module.args = {
            settings = neovim-settings;
            helpers = lib.mkForce helpers;
            lib = lib.mkForce lib // {inherit helpers;};
          };
        }

        neovim-config
      ];
    };
  };
in
  raw-neovim
