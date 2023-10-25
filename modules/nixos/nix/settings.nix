{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.nix;

  users =
    ["root" "@wheel" config.milkyway.user.name]
    ++ optional config.services.hydra.enable "hydra";
in {
  nix.settings =
    {
      trusted-users = mkDefault users;
      allowed-users = mkDefault users;

      # Large builds apparently fail due to an issue with darwin:
      # https://github.com/NixOS/nix/issues/4119
      sandbox = false;

      # Max number of parallel jobs
      max-jobs = mkDefault "auto";

      keep-outputs = mkDefault true;
      keep-derivations = mkDefault true;

      log-lines = mkDefault 50;
      warn-dirty = mkDefault false;
      accept-flake-config = mkDefault true;
      auto-optimise-store = mkDefault true;

      # Use available binary caches, this is not Gentoo
      # this also allows us to use remote builders to reduce build times and batter usage
      builders-use-substitutes = true;

      experimental-features = [
        "flakes"
        "repl-flake"
        "nix-command"
      ];

      # Enable certain system features
      system-features = ["big-parallel" "kvm" "recursive-nix"];

      substituters =
        [cfg.default-substituter.url]
        ++ (mapAttrsToList (name: _value: name) cfg.extra-substituters);

      trusted-public-keys =
        [cfg.default-substituter.key]
        ++ (mapAttrsToList (_name: value: value.key) cfg.extra-substituters);

      # home-manager will attempt to rebuild the world otherwise...
      trusted-substituters = [
        "https://nixpkgs-wayland.cachix.org"
        "https://cache.nixos.org?priority=7"
        "https://nix-community.cachix.org?priority=5"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store/?priority=10"
      ];

      extra-trusted-public-keys = ["viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="];
    }
    // (optionalAttrs (pkgs.stdenv.isDarwin && pkgs.stdenv.isAarch64) {
      extra-platforms = "aarch64-darwin x86_64-darwin";
    });
}
