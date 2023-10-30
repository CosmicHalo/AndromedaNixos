{pkgs, ...}: {
  config = {
    extraPlugins = with pkgs.vimPlugins; [
      friendly-snippets
    ];
    plugins = {
      luasnip.enable = true;
      cmp_luasnip.enable = true;

      cmp-path.enable = true;
      cmp-emoji.enable = true;
      cmp-buffer.enable = true;
      cmp-latex-symbols.enable = true;

      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-nvim-lsp-document-symbol.enable = true;

      lspkind = {
        enable = true;
        cmp.enable = true;
        # mode = "symbol";
        mode = "symbol_text";
      };
    };
  };
}
