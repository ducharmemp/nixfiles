local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local match = "^caffeinate -dim$"

local caffeine = sbar.add("item", "widgets.caffeine", {
  position = "right",
  icon = {
    string = icons.caffeine.off,
    color = colors.grey,
    font = {
      style = settings.font.style_map["Regular"],
      size = 16.0,
    },
  },
  label = { drawing = false },
  update_freq = 60,
})

local function render(active)
  caffeine:set({
    icon = {
      string = active and icons.caffeine.on or icons.caffeine.off,
      color = active and colors.yellow or colors.grey,
    },
  })
end

local function refresh()
  sbar.exec("pgrep -f '" .. match .. "' >/dev/null && echo on || echo off", function(state)
    render(state:find("on") ~= nil)
  end)
end

caffeine:subscribe({ "forced", "routine", "system_woke" }, refresh)

caffeine:subscribe("mouse.clicked", function()
  sbar.exec(
    "if pgrep -f '" .. match .. "' >/dev/null; then pkill -f '" .. match .. "'; echo off; "
      .. "else nohup caffeinate -dim >/dev/null 2>&1 & echo on; fi",
    function(state)
      render(state:find("on") ~= nil)
    end
  )
end)

sbar.add("bracket", "widgets.caffeine.bracket", { caffeine.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.caffeine.padding", {
  position = "right",
  width = settings.group_paddings
})
