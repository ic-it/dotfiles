local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux
local config = {}


config.keys = {
  {
    key = 'n',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.ToggleFullScreen,
  },
}



-- config.enable_tab_bar = false
config.color_scheme = "nord" -- or Macchiato, Frappe, Latte
config.window_decorations = "NONE"
config.window_background_opacity = 0.91
config.window_background_gradient = {
  colors = { '#282c34', '#202125' },
  orientation = { Linear = { angle = -45.0 } },
}

return config
