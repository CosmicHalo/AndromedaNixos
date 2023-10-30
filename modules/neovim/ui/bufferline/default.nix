_: {
  config.plugins.bufferline = {
    enable = true;

    sortBy = "id";
    tabSize = 18;
    themable = true;
    mode = "buffers";
    colorIcons = true;
    truncateNames = true;

    modifiedIcon = "●";
    numbers = "buffer_id";
    leftTruncMarker = "";
    rightTruncMarker = "";
    separatorStyle = "thin";
    enforceRegularTabs = false;

    closeIcon = "";
    bufferCloseIcon = "";
    closeCommand = "bdelete! %d";

    diagnostics = "nvim_lsp";
    diagnosticsIndicator = null;
    diagnosticsUpdateInInsert = true;

    showCloseIcon = true;
    showBufferIcons = true;
    showTabIndicators = true;
    showDuplicatePrefix = true;
    alwaysShowBufferline = true;
    showBufferCloseIcons = true;

    # groups = {
    #   items = [];
    #   options = {
    #     toggleHiddenOnEnter = true;
    #   };
    # };

    indicator = {
      icon = "▎";
      style = "underline";
    };

    hover = {
      enabled = true;
      # reveal = [];
      delay = 200;
    };

    customFilter = ''
      function(buf_number, buf_numbers)
        -- filter out filetypes you don't want to see
        if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
            return true
        end

        -- filter out by buffer name
        if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
            return true
        end

        -- filter out based on arbitrary rules
        -- e.g. filter out vim wiki buffer from tabline in your work repo
        if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
            return true
        end

        -- filter out by it's index number in list (don't show first buffer)
        if buf_numbers[1] ~= buf_number then
            return true
        end
      end
    '';

    getElementIcon = ''
      function(element)
        -- element consists of {filetype: string, path: string, extension: string, directory: string}
        -- This can be used to change how bufferline fetches the icon
        -- for an element e.g. a buffer or a tab.
        -- e.g.
        local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(opts.filetype, { default = false })
        return icon, hl
      end
    '';
  };
}
