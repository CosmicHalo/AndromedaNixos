{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.zellij;
  yamlFormat = pkgs.formats.yaml {};

  mkSettingsOpt = default: mkOpt yamlFormat.type default;

  default-plugins = {
    tab-bar = {path = "tab-bar";};
    strider = {path = "strider";};
    status-bar = {path = "status-bar";};
    compact-bar = {path = "compact-bar";};
    session-manager = {path = "session-manager";};
  };
in {
  options.milkyway.apps.zellij = with types; {
    enable = mkEnableOption "zellij";
    enableZshIntegration = mkEnableOption "zsh integration";

    plugins =
      mkSettingsOpt default-plugins
      "Zellij theme configuration."
      // {
        examples = {
          tab-bar = {path = "tab-bar";};
          strider = {path = "strider";};
          status-bar = {path = "status-bar";};
          compact-bar = {path = "compact-bar";};
          session-manager = {path = "session-manager";};
        };
      };

    settings =
      mkCompositeOption' ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/zellij/config.yaml`.

        See <https://zellij.dev/documentation> for the full
        list of options.
      '' {
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
          mkStrOpt "default"
          "The default layout to use.";
        default_mode =
          mkStrOpt "normal"
          "hoose the mode that zellij uses when starting up.";

        mouse_mode = mkBoolOpt false ''
          Toggle enabling the mouse mode.

          On certain configurations, or terminals this could
          potentially interfere with copying text.
        '';
        scroll_buffer_size =
          mkIntOpt 1000
          "Configure the scroll back buffer size";
        copy_command = mkStrOpt "xclip -selection clipboard" ''
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

        theme_dir = mkNullOpt str null "The directory to load themes from.";
        layout_dir = mkNullOpt str null "The directory to load themes from.";
      };
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      package = pkgs.milkyway.zellij;

      inherit (cfg) enableZshIntegration;

      settings =
        cfg.settings
        // {
          inherit (cfg) plugins;
          theme_dir = mkIf (cfg.settings.theme_dir != null) cfg.settings.theme_dir;
          layout_dir = mkIf (cfg.settings.layout_dir != null) cfg.settings.layout_dir;
        };
    };
  };
}
