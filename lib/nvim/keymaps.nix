{lib, ...}: let
  inherit
    (lib)
    types
    isString
    hasInfix
    mapAttrs
    attrValues
    ;

  inherit
    (lib.milkyway)
    vim
    mkOpt
    ifNonNull'
    mkStrOpt
    mkBoolOpt
    mkNullOrOption
    defaultNullOpts
    mkNullCompositeOption'
    ;
in rec {
  # These are the configuration options that change the behavior of each mapping.
  mapConfigOptions = {
    silent =
      defaultNullOpts.mkBool false
      "Whether this mapping should be silent. Equivalent to adding <silent> to a map.";

    nowait =
      defaultNullOpts.mkBool false
      "Whether to wait for extra input on ambiguous mappings. Equivalent to adding <nowait> to a map.";

    script =
      defaultNullOpts.mkBool false
      "Equivalent to adding <script> to a map.";

    expr =
      defaultNullOpts.mkBool false
      "Means that the action is actually an expression. Equivalent to adding <expr> to a map.";

    unique =
      defaultNullOpts.mkBool false
      "Whether to fail if the map is already defined. Equivalent to adding <unique> to a map.";

    noremap =
      defaultNullOpts.mkBool true
      "Whether to use the 'noremap' variant of the command, ignoring any custom mappings on the defined action. It is highly advised to keep this on, which is the default.";

    remap =
      defaultNullOpts.mkBool false
      "Make the mapping recursive. Inverses \"noremap\"";

    desc =
      mkNullOrOption types.str
      "A textual description of this keybind, to be shown in which-key, if you have it.";
  };

  modes = {
    insert.short = "i";
    normal.short = "n";
    select.short = "s";
    command.short = "c";
    terminal.short = "t";
    operator.short = "o";

    visual = {
      desc = "visual and select";
      short = "v";
    };

    visualOnly = {
      desc = "visual only";
      short = "x";
    };

    normalVisualOp = {
      desc = "normal, visual, select and operator-pending (same as plain 'map')";
      short = "";
    };

    lang = {
      desc = "normal, visual, select and operator-pending (same as plain 'map')";
      short = "l";
    };

    insertCommand = {
      desc = "insert and command-line";
      short = "!";
    };
  };

  modeList =
    map
    (
      {short, ...}: short
    )
    (attrValues modes);

  modeEnum =
    types.enum
    # ["" "n" "v" ...]
    (
      map
      (
        {short, ...}: short
      )
      (attrValues modes)
    );

  mkModeMaps = defaults:
    mapAttrs
    (
      _key: action: let
        actionAttrs =
          if isString action
          then {inherit action;}
          else action;
      in
        defaults // actionAttrs
    );

  mkMaps = defaults:
    mapAttrs
    (
      _name: modeMaps:
        mkModeMaps defaults modeMaps
    );

  # TODO: When `maps` will have to be deprecated (early December 2023), change this.
  # mapOptionSubmodule = {...} (no need for options... except for 'optionalAction')
  keymapOptionSubmodule = with types; let
    mapOptionSubmodule = submodule {
      options =
        {
          key =
            mkStrOpt "" "The key to map."
            // {example = "<C-m>";};
          desc =
            mkStrOpt ""
            "The description of the mapping.";
          action =
            defaultNullOpts.mkLines ""
            "The action to execute.";
          lua = mkBoolOpt false ''
            If true, `action` is considered to be lua code.
            Thus, it will not be wrapped in `""`.
          '';
        }
        // {
          options = mapConfigOptions;
        };
    };
  in
    mapOptionSubmodule;

  mkKeymaps = desc: let
    mappingCfg = key: {
      "${key}" =
        mkOpt (types.attrsOf vim.keymaps.keymapOptionSubmodule) {}
        "Mappings for [${key}] mode";
    };
  in
    (mkNullCompositeOption' desc
      (builtins.foldl' (acc: key: acc // mappingCfg key) {} vim.keymaps.modeList))
    // {
      apply = keyMappings:
        ifNonNull' keyMappings
        (mapAttrs (_: keyMap:
          mapAttrs (_n: keyMapping: let
            isLua = keyMapping.lua || hasInfix "function" keyMapping.action;
            __unkeyed =
              if isLua
              then vim.mkRaw keyMapping.action
              else keyMapping.action;
          in {
            inherit __unkeyed;
            inherit (keyMapping) desc;
          })
          keyMap)
        keyMappings);
    };
}
