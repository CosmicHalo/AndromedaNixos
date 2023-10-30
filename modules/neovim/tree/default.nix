_: {
  config = {
    plugins.neo-tree = {
      enable = true;
      closeIfLastWindow = false;

      window = {
        width = 30;
        autoExpandWidth = true;
      };
    };

    maps.normal."<leader>e" = {
      silent = true;
      desc = "file tree";
      action = ":Neotree action=focus reveal toggle<CR>";
    };
  };
}
