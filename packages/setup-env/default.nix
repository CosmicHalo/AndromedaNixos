{writeShellScriptBin}: let
  scriptPath = ./setup-env.js;
in
  writeShellScriptBin "setup-env" ''
    node ${scriptPath}
  ''
