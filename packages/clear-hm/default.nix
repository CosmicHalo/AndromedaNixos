{pkgs, ...}:
pkgs.writeShellScriptBin "clear-hm" ''
  GENERATIONS=$(home-manager generations | awk -v RS='id [0-9]+' '$0=RT' | awk '{print $2}') | set "$\{@:2}"
  echo "Generations to remove: => [$GENERATIONS"]
  home-manager remove-generations $GENERATIONS
  echo "Done!"4
''
