_: {
  config.plugins = {
    nvim-cmp = {
      enable = true;
      snippet.expand = "luasnip";

      completion = {
        keywordLength = 3;
        autocomplete = ["TextChanged"];
      };

      sources = [
        {name = "path";}
        {name = "emoji";}
        {name = "buffer";}
        {name = "luasnip";}
        {name = "nvim_lsp";}
        {name = "latex_symbols";}
        {name = "nvim_lsp_signature_help";}
        {name = "nvim_lsp_document_symbol";}
      ];

      formatting = {
        expandableIndicator = true;
        fields = ["abbr" "kind" "menu"];
      };

      matching = {
        disallowFuzzyMatching = false;
        disallowFullfuzzyMatching = false;
        disallowPartialFuzzyMatching = true;
        disallowPartialMatching = false;
        disallowPrefixUnmatching = false;
      };

      window = {
        documentation.maxHeight = "math.floor(40 * (40 / vim.o.lines))";
        completion = {
          colOffset = -3;
          sidePadding = 0;
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
        };
      };

      mapping = {
        "<C-k>" = "cmp.mapping.select_prev_item()";
        "<C-j>" = "cmp.mapping.select_next_item()";
        "<C-e>" = "cmp.mapping.abort()";
        "<CR>" = ''
          cmp.mapping {
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm { select = true },
            c = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
          },
        '';
        "<C-b>" = "cmp.mapping.scroll_docs(-2)";
        "<C-f>" = "cmp.mapping.scroll_docs(2)";
      };
    };
  };
}
