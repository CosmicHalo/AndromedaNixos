{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.shell.zsh;

  pluginModule = with types;
    types.submodule {
      options = {
        name = mkOpt str null "The name of the plugin.";
        src = mkOpt path null "Path to the plugin folder.";
        file = mkOpt str null "The plugin script to source.";
      };
    };
in {
  options.milkyway.shell.zsh = with types; {
    plugins = mkOpt (listOf pluginModule) [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "406ce293f5302fdebca56f8c59ec615743260604";
          sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
        };
      }
    ] "List of zsh plugins to install.";

    zplug = {
      enable = mkBoolOpt true "zplug - a zsh plugin manager";
      plugins = mkOpt (listOf str) [] "List of regular zplug plugins.";
      theme-plugins = mkOpt (listOf str) [] "List of zplug theme plugins.";
      oh-my-zsh-plugins = mkOpt (listOf str) [] "List of zplug OMZSH plugins.";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      inherit (cfg) plugins;

      zplug = let
        generate-plugins = zsh-fn:
          lists.map (p: let
            expr = builtins.split "\," p;
          in
            zsh-fn (head expr) (
              if (length expr == 1)
              then []
              else singleton (strings.removePrefix " " (last expr))
            ));
        create-zsh-plugin = name: tags: {
          inherit name;
          tags =
            if (tags != null)
            then tags
            else [];
        };
        create-zsh-theme-plugin = name: extraTags:
          create-zsh-plugin "${name}" (extraTags ++ ["as:theme"]);
        create-omzsh-plugin = name: extraTags:
          create-zsh-plugin "plugins/${name}" (extraTags ++ ["from:oh-my-zsh"]);
      in
        mkIf cfg.zplug.enable {
          enable = true;
          plugins =
            generate-plugins create-zsh-plugin cfg.zplug.plugins
            ++ generate-plugins create-zsh-theme-plugin cfg.zplug.theme-plugins
            ++ generate-plugins create-omzsh-plugin cfg.zplug.oh-my-zsh-plugins;
        };
    };
  };
}
