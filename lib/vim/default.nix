_: rec {
  nixvim = rec {
    # Correctly merge two attrs (partially) representing a mapping.
    mergeKeymap = defaults: keymap: let
      # First, merge the `options` attrs of both options.
      mergedOpts = (defaults.options or {}) // (keymap.options or {});
    in
      # Then, merge the root attrs together and add the previously merged `options` attrs.
      (defaults // keymap) // {options = mergedOpts;};

    mkKeymaps = defaults:
      map
      (mergeKeymap defaults);
  };

  vim = rec {
    ######################################################################

    ##########
    # Key map
    ##########
    mkKeymap = key: action: desc: options: {
      inherit key action;
      options = options // {inherit desc;};
    };
    mkKeymap' = key: action: desc: (mkKeymap key action desc {});

    # LUA
    mkLuaKeymap = key: action: desc: extraKeymapConfig: options:
      {
        inherit key action;
        lua = true;
        options = options // {inherit desc;};
      }
      // extraKeymapConfig;
    mkLuaKeymap' = key: action: desc: (mkLuaKeymap key action desc {} {});

    mkNLuaKeymap = key: action: desc: options: (mkLuaKeymap key action desc {mode = "n";} options);
    mkNLuaKeymap' = key: action: desc: (mkNLuaKeymap key action desc {});

    ###########
    # Key maps
    ###########
    mkKeymaps = defaults: bindings: let
      raw-bindings = builtins.map (binding:
        builtins.foldl' (f: f)
        mkKeymap'
        binding)
      bindings;
    in
      nixvim.mkKeymaps defaults raw-bindings;

    mkKeymaps' = bindings: let
      raw-bindings = builtins.map (binding:
        builtins.foldl' (f: f)
        mkKeymap'
        binding)
      bindings;
    in
      nixvim.mkKeymaps {} raw-bindings;

    mkLuaKeymaps' = bindings: (mkLuaKeymaps {} bindings);
    mkLuaKeymaps = defaults: bindings: let
      raw-bindings = builtins.map (binding:
        builtins.foldl' (f: f)
        mkLuaKeymap'
        binding)
      bindings;
    in
      nixvim.mkKeymaps defaults raw-bindings;

    ##########
    # Helpers
    ##########
    mkNKeymaps = bindings: (mkKeymaps {mode = "n";} bindings);
    mkLuaNKeymaps = bindings: (mkLuaKeymaps {mode = "n";} bindings);
  };
}
