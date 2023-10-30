_: {
  config.plugins = {
    lsp-lines.enable = true;

    fidget = {
      enable = true;
      text = {
        spinner = "bouncing_ball";
      };

      window = {
        blend = 90;
      };
    };

    trouble = {
      enable = true;
      mode = "workspace_diagnostics";
    };

    lsp = {
      enable = true;

      servers = {
        # bashls.enable = true;
        # eslint.enable = true;
        # jsonls.enable = true;
        # tsserver.enable = true;
        # nil_ls = {
        #   enable = true;
        #   formatting.command = "alejandra";
        # };
      };
    };
  };
}
