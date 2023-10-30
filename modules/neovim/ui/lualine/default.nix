_: {
  config.plugins.lualine = {
    enable = true;

    theme = "auto";
    iconsEnabled = true;

    globalstatus = false;
    alwaysDivideMiddle = true;

    componentSeparators = {
      left = "";
      right = "";
    };

    refresh = {
      statusline = 1000;
      tabline = 1000;
      winbar = 1000;
    };

    sectionSeparators = {
      left = "";
      right = "";
    };
    sections = {
      lualine_a = ["mode"];
      lualine_b = ["branch" "diff" "diagnostics"];
      lualine_c = ["filename"];
      lualine_x = ["encoding" "fileformat" "filetype"];
      lualine_y = ["progress"];
      lualine_z = ["location"];
    };
    inactiveSections = {
      lualine_c = ["filename"];
      lualine_x = ["location"];
    };
  };
}
