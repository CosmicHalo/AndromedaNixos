_: {
  config = {
    plugins = {
      rainbow-delimiters.enable = true;

      treesitter = {
        enable = true;
        indent = true;
        nixGrammars = true; # install grammars with Nix
        nixvimInjections = true; # Lua in extraConfigLua

        ensureInstalled = [
          "bash"
          "c"
          "html"
          "julia"
          "latex"
          "lua"
          "markdown"
          "nix"
          "python"
          "toml"
          "yaml"
        ];
      };
    };
  };
}
