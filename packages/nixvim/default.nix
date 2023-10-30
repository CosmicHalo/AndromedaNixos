{
  lib,
  pkgs,
  neovim-config ? {},
  neovim-settings ? {},
  ...
}: let
  inherit (pkgs.nixvim-lib) helpers;
  raw-modules =
    lib.andromeda.fs.get-default-nix-files-recursive
    (lib.andromeda.fs.get-file "/modules/neovim");

  wrapped-modules =
    builtins.map
    (
      raw-module: args: let
        result = import raw-module (args
          // {
            # NOTE: nixvim doesn't allow for these to be customized so we must work around the
            # module system here...
            inherit lib pkgs helpers;
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
            lib = lib.mkForce lib;
            settings = neovim-settings;
          };
        }

        neovim-config
      ];
    };
  };
in
  raw-neovim
