-- Add the sketchybar module to the package cpath (set by Nix wrapper)
local sbarlua_path = os.getenv("SBARLUA_PATH")
if sbarlua_path then
  package.cpath = package.cpath .. ";" .. sbarlua_path .. "/lib/sketchybar_lua/?.so"
else
  package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"
end

os.execute("(cd $CONFIG_DIR/helpers && make)")
