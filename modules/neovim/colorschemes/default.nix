_: {
  config = {
    colorschemes.catppuccin = {
      enable = true;
      flavour = "mocha";

      background = {
        light = "latte";
        dark = "mocha";
      };

      dimInactive = {
        shade = "dark";
        enabled = true;
        percentage = 0.15;
      };

      integrations = {
        aerial = true;
        cmp = true;
        gitsigns = true;
        hop = true;
        indent_blankline.enabled = true;
        lsp_trouble = true;
        mini = false;
        neogit = true;
        neotree = true;
        noice = true;
        notify = false;
        rainbow_delimiters = true;
        semantic_tokens = true;
        symbols_outline = true;
        telescope = true;
        treesitter_context = true;
        treesitter = true;
        which_key = true;
      };
    };
  };
}
