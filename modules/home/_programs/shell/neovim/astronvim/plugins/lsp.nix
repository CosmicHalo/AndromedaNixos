# This is the lazy file within nvim/lua/config
{
  lib,
  config,
  nvimPath,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.neovim.astronvim;
  cfgAstroLSP = cfg.astrolsp;
in {
  options.milkyway.programs.neovim.astronvim.astrolsp = with types; {
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
          features = ${vim.toLuaObject cfgAstroLSP.features},
          formatting = ${vim.toLuaObject cfgAstroLSP.formatting},
        ''
        + (mkStringIfNonEmpty cfgAstroLSP.capabilities ''
          capabilities = ${vim.toLuaObject cfgAstroLSP.capabilities},
        '')
        + (mkStringIfNonEmpty cfgAstroLSP.config ''
          config = ${vim.toLuaObject cfgAstroLSP.config},
        '')
        + (mkStringIfNonEmpty cfgAstroLSP.diagnostics ''
          diagnostics = ${vim.toLuaObject cfgAstroLSP.diagnostics},
        '')
        + (mkStringIfNonEmpty cfgAstroLSP.flags ''
          flags = ${vim.toLuaObject cfgAstroLSP.flags},
        '')
        + (mkStringIfNonNull cfgAstroLSP.handlers ''
          handlers = ${vim.toLuaObject cfgAstroLSP.handlers},
        '')
        + (mkStringIfNonNull cfgAstroLSP.mappings ''
          mappings = ${vim.toLuaObject cfgAstroLSP.mappings},
        '')
        + (mkStringIfNonEmpty cfgAstroLSP.servers ''
          servers = ${vim.toLuaObject cfgAstroLSP.servers},
        '')
        + (mkStringIfNonNull cfgAstroLSP.on_attach ''
          on_attach = ${vim.toLuaObject cfgAstroLSP.on_attach},
        '');
    in {
      "${nvimPath}/astrolsp.lua".text = ''
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
