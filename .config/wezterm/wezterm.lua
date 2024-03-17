local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Muse (terminal.sexy)'
config.font = wezterm.font 'Fira Code'
config.font_size = 14.0
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}
-- disable ligatures
config.harfbuzz_features = { 'calt=0' }

-- command palet
config.command_palette_font_size = 16
-- config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
-- config.window_close_confirmation = "NeverPrompt"
config.window_background_opacity = 0.9
config.text_background_opacity = 1.0

-- key bindings
config.keys = {
  {
    key = 'p',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateCommandPalette,
  },
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal {},
  },
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical {},
  },
}

return config
