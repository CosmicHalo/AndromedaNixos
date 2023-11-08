{lib, ...}:
lib.andromeda.fs
// {
  get-lua-files = path:
    builtins.filter
    (lib.andromeda.path.has-file-extension "lua")
    (lib.andromeda.fs.get-files path);
}
