{
  lib,
  pkgs,
  config,
  inputs,
  isDarwin,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.zellij;
  yamlFormat = pkgs.formats.yaml {};
  mkSettingsOpt = default: mkOpt yamlFormat.type default;

  zellij_input = ["zellij-forgot" "zellij-room" "zellij-zjstatus"];
  zellij_replacements = [
    "${inputs.zellij-forgot.outPath}"
    "${inputs.zellij-room.outPath}"
    "${pkgs.zjstatus}/bin/zjstatus.wasm"
  ];

  genLayout = layout: let
    layoutName = builtins.unsafeDiscardStringContext (builtins.baseNameOf layout);
  in {
    "zellij/layouts/${layoutName}".text =
      replaceTextInFile zellij_input zellij_replacements layout;
  };
  genLayoutFromDir = dir:
    foldl' (acc: layout: acc // genLayout layout) {}
    (lib.milkyway.fs.get-files dir);

  default-plugins = {
    tab-bar = {path = "tab-bar";};
    strider = {path = "strider";};
    status-bar = {path = "status-bar";};
    compact-bar = {path = "compact-bar";};
    session-manager = {path = "session-manager";};
  };

  default-themes = {
    catppuccin-frappe = {
      bg = "#626880"; # Surface2
      fg = "#c6d0f5";
      red = "#e78284";
      green = "#a6d189";
      blue = "#8caaee";
      yellow = "#e5c890";
      magenta = "#f4b8e4"; # Pink
      orange = "#ef9f76"; # Peach
      black = "#292c3c"; # Mantle
      white = "#c6d0f5";
    };
    catppuccin-macchiato = {
      bg = "#5b6078"; # Surface2
      fg = "#cad3f5";
      red = "#ed8796";
      green = "#a6da95";
      blue = "#8aadf4";
      yellow = "#eed49f";
      magenta = "#f5bde6"; # Pink
      orange = "#f5a97f"; # Peach
      cyan = "#91d7e3"; # Sky
      black = "#1e2030"; # Mantle
      white = "#cad3f5";
    };
    catppuccin-mocha = {
      bg = "#585b70"; # Surface2
      fg = "#cdd6f4";
      red = "#f38ba8";
      green = "#a6e3a1";
      blue = "#89b4fa";
      yellow = "#f9e2af";
      magenta = "#f5c2e7"; # Pink
      orange = "#fab387"; # Peach
      cyan = "#89dceb"; # Sky
      black = "#181825"; # Mantle
      white = "#cdd6f4";
    };
  };

  generatedKeymaps =
    replaceTextInFile zellij_input zellij_replacements
    ./config/keymaps.kdl;

  finalSettings =
    "${generatedKeymaps}\n"
    + lib.home-manager.hm.generators.toKDL {} cfg.settings;
in {
  options.milkyway.programs.zellij = with types; {
    enable = mkEnableOption "zellij";
    enableZshIntegration = mkEnableOption "zsh integration";
    package = mkPackageOpt pkgs.zellij "The zellij package to use";

    plugins =
      mkSettingsOpt default-plugins
      "Zellij theme configuration."
      // {
        example = {
          tab-bar = {path = "tab-bar";};
          strider = {path = "strider";};
          status-bar = {path = "status-bar";};
          compact-bar = {path = "compact-bar";};
          session-manager = {path = "session-manager";};
        };
      };

    themes =
      mkSettingsOpt default-themes
      "Zellij theme configuration."
      // {
        example = {
          bg = "#585b70"; # Surface2
          fg = "#cdd6f4";
          red = "#f38ba8";
          green = "#a6e3a1";
          blue = "#89b4fa";
          yellow = "#f9e2af";
          magenta = "#f5c2e7"; # Pink
          orange = "#fab387"; # Peach
          cyan = "#89dceb"; # Sky
          black = "#181825"; # Mantle
          white = "#cdd6f4";
        };
      };

    layouts = mkOpt (listOf (submodule {
      options = {
        name = mkStrOpt null "The name of the layouts submodule.";
        source =
          mkOpt (either lines path) null
          "The source to the layout. Either a path or lines.";
      };
    })) [] "Zellij layout configuration.";

    settings =
      mkCompositeOption' ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/zellij/config.yaml`.

        See <https://zellij.dev/documentation> for the full
        list of options.
      '' {
        default_shell =
          mkStrOpt "zsh"
          "The default shell to use.";
        default_cwd =
          mkStrOpt ""
          "The default working directory to use.";
        theme =
          mkStrOpt "dracula"
          "The theme to use.";
        default_layout =
          mkStrOpt "main"
          "The default layout to use.";
        default_mode =
          mkStrOpt "normal"
          "hoose the mode that zellij uses when starting up.";

        simplified_ui =
          mkBoolOpt false
          "Simplify the UI by removing the tab bar and status bar.";
        pane_frames =
          mkBoolOpt false
          "Display a frame around each pane.";
        auto_layout =
          mkBoolOpt true
          "Toggle between having Zellij lay out panes according to a predefined set of layouts whenever possible";
        session_serialization =
          mkBoolOpt true
          "Save and restore the state of the terminal when exiting and restarting Zellij.";
        serialize_pane_viewport =
          mkBoolOpt false
          "Whether pane viewports are serialized along with the session";

        on_force_close =
          mkEnumOpt ["quit" "detach"] "detach"
          "Choose what to do when zellij receives SIGTERM, SIGINT, SIGQUIT or SIGHUP.";
        scrollback_lines_to_serialize =
          mkIntOpt 1000
          "crollback lines to serialize along with the pane viewport when serializing sessions";

        mouse_mode = mkBoolOpt true ''
          Toggle enabling the mouse mode.

          On certain configurations, or terminals this could
          potentially interfere with copying text.
        '';
        scroll_buffer_size =
          mkIntOpt 1000
          "Configure the scroll back buffer size";
        copy_command =
          mkStrOpt (
            if isDarwin
            then "pbcopy"
            else "xclip -selection clipboard"
          ) ''
            The command to use to copy text to the clipboard.

            This command is run in a shell, so you can use pipes
            and other shell features.
          '';
        copy_clipboard =
          mkEnumOpt ["system" "primary"] "system"
          ''Choose the destination for copied text'';
        copy_on_select = mkBoolOpt true ''
          Toggle copying text to the clipboard when selecting text.

          This is useful for copying text without having to
          right click and select copy.
        '';
        scrollback_editor =
          mkStrOpt "${pkgs.neovim}/bin/nvim"
          ''Path to the default editor to use to edit pane scrollbuffer'';
        mirror_session =
          mkBoolOpt false
          "When attaching to an existing session with other users, should the session be mirrored (true)";
        styled_underlines =
          mkBoolOpt true
          "Enable or disable the rendering of styled and colored underlines (undercurl).";

        theme_dir =
          mkNullOpt str null "The directory to load themes from.";
        layout_dir =
          mkNullOpt str "${config.home.homeDirectory}/.config/zellij/layouts"
          "The directory to load themes from.";
      }
      // {
        apply = settings:
          attrsets.mergeAttrsList [
            (builtins.removeAttrs settings ["theme_dir" "layout_dir"])
            {inherit (cfg) plugins;}
          ]
          // ifNonNullAttr settings.theme_dir {
            inherit (settings) theme_dir;
          }
          // ifNonNullAttr settings.layout_dir {
            inherit (settings) layout_dir;
          };
      };
  };

  config = mkIf cfg.enable {
    xdg.configFile = let
      generatedDirLayouts = genLayoutFromDir ./layouts;
      generatedLayouts =
        generatedDirLayouts
        // (
          foldl' (acc: layout:
            acc
            // {
              "zellij/layouts/${layout.name}".text =
                if builtins.isString layout.source
                then layout.source
                else replaceTextInFile zellij_input zellij_replacements layout.source;
            }) {}
          cfg.layouts
        );
    in
      {"zellij/config.kdl".text = finalSettings;} // generatedLayouts;

    programs.zellij = {
      enable = true;
      inherit (cfg) package enableZshIntegration;
    };
  };
}
