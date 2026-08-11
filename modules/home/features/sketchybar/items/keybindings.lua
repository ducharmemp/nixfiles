local colors = require("colors")
local settings = require("settings")

-- which-key style helper: a menubar item that pops a panel listing the rift
-- keybindings. Toggled by clicking the item, or by the custom event
-- `keybindings_toggle` which rift triggers from a hotkey (see the rift home
-- module's keys: "Alt + Slash + ..." style exec binding).
--
-- The list below mirrors the [keys] table in the rift config. Keep the two in
-- sync when you change bindings.
local groups = {
  { header = "Focus / Workspace (Alt)" },
  { key = "Alt + H / J / K / L", desc = "focus left / down / up / right" },
  { key = "Alt + 0 .. 3", desc = "switch to workspace N" },
  { key = "Alt + Tab", desc = "last workspace" },
  { key = "Alt + Z", desc = "toggle rift on this space" },
  { key = "Alt + F", desc = "fullscreen" },
  { key = "Alt + Comma", desc = "toggle stack" },
  { key = "Alt + Slash", desc = "toggle orientation" },
  { key = "Alt + Enter", desc = "open Terminal" },

  { header = "Move / Resize (Alt + Shift)" },
  { key = "Alt + Shift + H / J / K / L", desc = "move node left / down / up / right" },
  { key = "Alt + Shift + 0 .. 3", desc = "move window to workspace N" },
  { key = "Alt + Shift + ← / → / ↑ / ↓", desc = "join window" },
  { key = "Alt + Shift + Space", desc = "toggle floating" },
  { key = "Alt + Shift + = / -", desc = "grow / shrink" },
  { key = "Alt + Shift + F", desc = "fullscreen within gaps" },

  { header = "Misc" },
  { key = "Alt + Ctrl + E", desc = "unjoin windows" },
  { key = "Alt + Shift + D", desc = "debug (print layout tree)" },
}

-- Custom event rift triggers (via `sketchybar --trigger keybindings_toggle`)
-- to open/close the panel from a hotkey.
sbar.add("event", "keybindings_toggle")

local keybindings = sbar.add("item", "keybindings", {
  position = "right",
  icon = {
    string = "⌨",
    font = { size = 16.0 },
    padding_left = 8,
    padding_right = 8,
    color = colors.white,
  },
  label = { drawing = false },
  background = {
    color = colors.bg2,
    border_color = colors.black,
    border_width = 1,
  },
  padding_left = 1,
  padding_right = 1,
  -- This item lives on the right of the bar; align the popup to the right so it
  -- grows leftward into the screen instead of overflowing the right display edge
  -- (which pushed it across the display seam on a multi-monitor setup).
  popup = { align = "right" },
})

-- Build the popup rows once.
for _, row in ipairs(groups) do
  if row.header then
    sbar.add("item", {
      position = "popup." .. keybindings.name,
      icon = {
        string = row.header,
        align = "left",
        width = 320,
        color = colors.blue,
        font = { style = settings.font.style_map["Bold"] },
      },
      label = { drawing = false },
      background = { color = colors.transparent },
    })
  else
    sbar.add("item", {
      position = "popup." .. keybindings.name,
      icon = {
        string = row.key,
        align = "left",
        width = 200,
        color = colors.yellow,
      },
      label = {
        string = row.desc,
        align = "left",
        width = 260,
        color = colors.white,
      },
    })
  end
end

local function toggle()
  keybindings:set({ popup = { drawing = "toggle" } })
end

keybindings:subscribe("mouse.clicked", toggle)
keybindings:subscribe("keybindings_toggle", toggle)

sbar.add("bracket", "keybindings.bracket", { keybindings.name }, {
  background = { color = colors.transparent, height = 30, border_color = colors.grey },
})

sbar.add("item", "keybindings.padding", {
  position = "right",
  width = settings.group_paddings,
})
