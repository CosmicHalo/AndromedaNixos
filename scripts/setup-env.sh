#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

checkAndClearDir(){
  
}

mkdir -p /etc/nixos/
mkdir -p ~/.config/home-manager/

ln -s $SCRIPT_DIR/flake.nix /etc/nixos/flake.nix
ln -s $SCRIPT_DIR/flake.nix ~/.config/home-manager/flake.nix