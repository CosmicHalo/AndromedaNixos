{
  lib,
  pkgs,
  ...
}:
with lib; let
  mkNeovim = {
    plugins ? [],
    wrapRc ? true,
    appName ? null,
    viAlias ? true,
    vimAlias ? true,
    withRuby ? false,
    extraPackages ? [],
    withPython3 ? true,
    withNodeJs ? false,
    extraPython3Packages ? _p: [],
    resolvedExtraLuaPackages ? [],
  }: let
    defaultPlugin = {
      runtime = {};
      plugin = null;
      config = null;
      optional = false;
    };

    externalPackages =
      extraPackages
      ++ [pkgs.sqlite];

    normalizedPlugins = map (x:
      defaultPlugin
      // (
        if x ? plugin
        then x
        else {plugin = x;}
      ))
    plugins;

    neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
      inherit extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias;
      plugins = normalizedPlugins;
    };

    customRC =
      ''
        vim.loader.enable()
      ''
      + (builtins.readFile ./nvim/init.lua)
      + neovimConfig.neovimRcContent;

    # + ''
    #   vim.opt.rtp:append('${../nvim}')
    # '';

    extraMakeWrapperArgs = builtins.concatStringsSep " " (
      (optional (appName != "nvim" && appName != null && appName != "")
        ''--set NVIM_APPNAME "${appName}"'')
      ++ (optional (externalPackages != [])
        ''--prefix PATH : "${makeBinPath externalPackages}"'')
      ++ (optional wrapRc
        ''--add-flags -u --add-flags "${pkgs.writeText "init.lua" customRC}"'')
      ++ [
        ''--set LIBSQLITE_CLIB_PATH "${pkgs.sqlite.out}/lib/libsqlite3.so"''
        ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.so"''
      ]
    );

    extraMakeWrapperLuaCArgs = optionalString (resolvedExtraLuaPackages != []) ''
      --suffix LUA_CPATH ";" "${
        lib.concatMapStringsSep ";" pkgs.luaPackages.getLuaCPath
        resolvedExtraLuaPackages
      }"'';

    extraMakeWrapperLuaArgs =
      optionalString (resolvedExtraLuaPackages != [])
      ''
        --suffix LUA_PATH ";" "${
          concatMapStringsSep ";" pkgs.luaPackages.getLuaPath
          resolvedExtraLuaPackages
        }"'';
  in
    pkgs.wrapNeovimUnstable pkgs.neovim-nightly (neovimConfig
      // {
        wrapperArgs =
          escapeShellArgs neovimConfig.wrapperArgs
          + " "
          + extraMakeWrapperArgs
          + " "
          + extraMakeWrapperLuaCArgs
          + " "
          + extraMakeWrapperLuaArgs;
        wrapRc = false;
      });

  nvim-pkg = mkNeovim {
    plugins = [];

    extraPackages = with pkgs; [
      sqls
      taplo # toml toolkit including a language server
      haskellPackages.fast-tags
      nodePackages.vim-language-server
      nodePackages.bash-language-server
      nodePackages.yaml-language-server
      nodePackages.vscode-json-languageserver-bin
      nodePackages.dockerfile-language-server-nodejs
    ];
  };
in
  nvim-pkg
