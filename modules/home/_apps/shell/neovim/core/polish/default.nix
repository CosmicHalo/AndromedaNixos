# This is the lazy file within nvim/lua/config
{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.neovim.astronvim;
in {
  options.milkyway.apps.neovim.polishcfg = with types;
    mkOpt lines ''''
    ''
      This file is automatically ran last in the setup process and is a good place to configure
      augroups/autocommands and custom filetypes also this just pure lua so
      anything that doesn't fit in the normal config locations above can go here
    ''
    // {
      example = ''
        -- Set up custom filetypes
        vim.filetype.add {
          extension = {
            foo = "fooscript",
          },
          filename = {
            ["Foofile"] = "fooscript",
          },
          pattern = {
            ["~/%.config/foo/.*"] = "fooscript",
          },
        }
      '';
    };

  config = mkIf cfg.enable {
    xdg.configFile = {
      "nvim/lua/config/polish.lua".text = concatStrings [
        ''
          -- This file is automatically ran last in the setup process and is a good place to configure
          -- augroups/autocommands and custom filetypes also this just pure lua so
          -- anything that doesn't fit in the normal config locations above can go here
        ''
        cfg.polishcfg
      ];
    };
  };
}
