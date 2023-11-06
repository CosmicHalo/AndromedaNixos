# This is the lazy file within nvim/lua/config
{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.neovim.astronvim;
  cfgAstroUI = cfg.plugins.astrolsp;
in {
  options.milkyway.apps.neovim.plugins.astrolsp = with types; {
    features = mkCompositeOption' "Configuration table of features provided by AstroLSP" {
      diagnostics_mode =
        mkOpt int 3
        "Diagnostics mode. (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = off)";

      inlay_hints = mkBoolOpt true "Enable/disable inlay hints on start";
      codelens = mkBoolOpt true "Enable/disable codelens refresh on start";
      lsp_handlers = mkBoolOpt true "Enable/disable setting of lsp_handlers";
      autoformat = mkBoolOpt true "Enable or disable auto formatting on start";
      semantic_tokens = mkBoolOpt true "Enable/disable semantic token highlighting";
    };

    capabilities =
      mkOpt (attrsOf attrs) {}
      ''Configure default capabilities for language servers (`:h vim.lsp.protocol.make_client.capabilities()`)'';

    config =
      mkOpt (attrsOf attrs) {}
      ''Configure language servers for `lspconfig`'';

    diagnostics =
      mkOpt attrs {}
      "Configure diagnostics options (`:h vim.diagnostic.config()`)";

    flags =
      mkOpt attrs {}
      "A custom flags table to be passed to all language servers  (`:h lspconfig-setup`)";

    formatting = mkCompositeOption' "Configuration options for controlling formatting with language servers" {
      format_on_save = mkCompositeOption' "Control auto formatting on save" {
        enabled = mkEnableOption "Enable/disable auto formatting on save";
        allow_filetypes = mkOpt (listOf str) [] "Enable format on save for specified filetypes only";
        ignore_filetypes = mkOpt (listOf str) [] "Disable format on save for specified filetypes only";
      };

      disabled =
        mkOpt (listOf str) []
        "Disable formatting capabilities for specific language servers";

      timeout_ms =
        mkIntOpt 1000
        "Timeout in milliseconds for formatting requests";

      filter =
        mkNullOrOption lines "Fully override the default formatting function"
        // {
          apply = filter:
            ifNonNull' filter (vim.mkRaw filter);
        };
    };

    handlers =
      mkNullOrOption (attrsOf (either bool lines)) "Configure how language servers get set up"
      // {
        example = ''
           handlers = {
            # default handler
            default = "
              function(server, opts)
                require("lspconfig")[server].setup(opts)
              end,
            ";

            # custom function handler for pyright
            pyright = "
              function(_, opts)
                require("lspconfig").pyright.setup(opts)
              end,
            ";

            # set to false to disable the setup of a language server
            rust_analyzer = false;
          },
        '';

        apply = handlers:
          ifNonNull' handlers
          (lib.mapAttrs' (n: v: let
            name =
              if n == "default"
              then "__unkeyed"
              else n;

            value =
              if isString v
              then vim.mkRaw v
              else v;
          in
            nameValuePair name value)
          handlers);
      };

    mappings =
      vim.keymaps.mkKeymaps
      "Configuration of mappings added when attaching a language server during the core `on_attach` function";

    servers =
      mkOpt (listOf str) []
      "A list like table of servers that should be setup, useful for enabling language servers not installed with Mason.";

    on_attach =
      mkNullOpt lines null
      "A custom `on_attach` function to be run after the default `on_attach` function, takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)"
      // {
        example = ''
          on_attach = "
            function(client, bufnr)
              -- do something
            end,
          ",
        '';

        apply = on_attach: vim.mkRawIfNonNull on_attach;
      };
  };

  config = mkIf cfg.enable {
    xdg.configFile = let
      opts =
        ''
          features = ${vim.toLuaObject cfgAstroUI.features},
          formatting = ${vim.toLuaObject cfgAstroUI.formatting},
        ''
        + (mkStringIfNonEmpty cfgAstroUI.capabilities ''
          capabilities = ${vim.toLuaObject cfgAstroUI.capabilities},
        '')
        + (mkStringIfNonEmpty cfgAstroUI.config ''
          config = ${vim.toLuaObject cfgAstroUI.config},
        '')
        + (mkStringIfNonEmpty cfgAstroUI.diagnostics ''
          diagnostics = ${vim.toLuaObject cfgAstroUI.diagnostics},
        '')
        + (mkStringIfNonEmpty cfgAstroUI.flags ''
          flags = ${vim.toLuaObject cfgAstroUI.flags},
        '')
        + (mkStringIfNonNull cfgAstroUI.handlers ''
          handlers = ${vim.toLuaObject cfgAstroUI.handlers},
        '')
        + (mkStringIfNonNull cfgAstroUI.mappings ''
          mappings = ${vim.toLuaObject cfgAstroUI.mappings},
        '')
        + (mkStringIfNonEmpty cfgAstroUI.servers ''
          servers = ${vim.toLuaObject cfgAstroUI.servers},
        '')
        + (mkStringIfNonNull cfgAstroUI.on_attach ''
          on_attach = ${vim.toLuaObject cfgAstroUI.on_attach},
        '');
    in {
      "nvim/lua/plugins/core/astrolsp.lua".text = ''
        return {
          "AstroNvim/astrolsp",
          lazy = false, -- disable lazy loading
          priority = 10000, -- load AstroCore first
          ---@type AstroUIConfig
          opts = {
            ${opts}
          }
        }
      '';
    };
  };
}
