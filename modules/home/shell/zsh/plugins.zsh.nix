{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.shell.zsh;
  cfgZplug = config.milkyway.shell.zsh.zplug;
  powerlevelEnabled = cfg.powerlevel10k.enable;

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
    powerlevel10k = mkEnableOpt' "Powerlevel10k";

    plugins =
      mkOpt (listOf pluginModule) []
      "List of zsh plugins to install.";

    zplug = {
      enable = mkBoolOpt true "zplug - a zsh plugin manager";
      plugins = mkOpt (listOf str) [] "List of regular zplug plugins.";
      theme-plugins = mkOpt (listOf str) [] "List of zplug theme plugins.";
      oh-my-zsh-plugins = mkOpt (listOf str) [] "List of zplug OMZSH plugins.";
    };

    z4hPlugins =
      mkOpt (listOf str) []
      "List of z4h plugins to install.";
  };

  config = mkIf cfg.enable {
    # Compile ZSH config files
    home.file.".p10k.zsh".source = ./config/p10k.zsh;

    programs.zsh = {
      plugins =
        [
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
        ]
        ++ cfg.plugins;

      zplug = let
        enabled =
          (builtins.length cfgZplug.plugins > 0)
          || (builtins.length cfgZplug.theme-plugins > 0)
          || (builtins.length cfgZplug.oh-my-zsh-plugins > 0);
      in
        mkIf cfgZplug.enable {
          enable = enabled;

          plugins = let
            # Add powerlevel10k if enabled
            cfgZplug.theme-plugins =
              cfgZplug.theme-plugins
              ++ lib.optional powerlevelEnabled ["romkatv/powerlevel10k, depth:1"];

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
            generate-plugins create-zsh-plugin cfgZplug.plugins
            ++ generate-plugins create-zsh-theme-plugin cfgZplug.theme-plugins
            ++ generate-plugins create-omzsh-plugin cfgZplug.oh-my-zsh-plugins;
        };
    };
  };
}
