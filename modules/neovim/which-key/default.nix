{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkynvim.which-key;
in {
  options.milkynvim.which-key = with types; {
    registrations =
      (mkOpt (attrsOf str) {} "Manually register the description of mappings.")
      // {
        example = {
          "<leader>p" = "Find git files with telescope";
        };
      };
  };

  config = {
    plugins.which-key = {
      inherit (cfg) registrations;

      enable = true;
      disable.filetypes = ["TelescopePrompt"];

      window = {
        winblend = 10;
        border = "double";
      };
    };

    # extraConfigLua = ''
    #   do
    #     vim.o.timeout = true
    #     vim.o.timeoutlen = 300
    #   end
    # '';
  };
}
