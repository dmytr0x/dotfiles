local wezterm = require("wezterm")
local act = wezterm.action

--
-- Config
--
local config = wezterm.config_builder()

config.default_prog = { "/opt/homebrew/bin/zsh", "--login" }
--
config.command_palette_font_size = 13
--
-- performance
config.enable_scroll_bar = true
--
-- scroll
-- CTRL-SHIFT-K and CMD-K will trigger the ClearScrollback action and discard
-- the contents of the scrollback buffer.
config.scrollback_lines = 10000

local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

local function colors_for_appearance(appearance)
  if appearance:find("Dark") then
    return {
      background = "#000000",
    }
  else
    return {
      background = "#ffffff",
    }
  end
end

--
-- Look and Feel
--
config.term = "xterm-256color"
config.front_end = "WebGpu"
config.webgpu_preferred_adapter = wezterm.gui.enumerate_gpus()[1]
config.prefer_egl = true
--
-- color scheme
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.colors = colors_for_appearance(wezterm.gui.get_appearance())
--
-- font
config.font = wezterm.font_with_fallback({
  { family = "Anonymous Pro", weight = "Regular", italic = true },
})
config.font_size = 15.0
config.line_height = 1.05
config.text_background_opacity = 1.0
-- disable ligatures for all fonts
config.harfbuzz_features = { "calt=0" }
--
-- tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
--
-- window
config.window_decorations = "RESIZE"
-- window_close_confirmation = "NeverPrompt",
config.macos_window_background_blur = 5
config.window_frame = {
  font = wezterm.font({ family = "Anonymous Pro", weight = "Regular", italic = true }),
  font_size = 15.0,
}
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}
--
-- Keys & Key Tables
--
config.disable_default_key_bindings = false

config.leader = {
  key = "Space",
  mods = "CTRL|ALT|CMD",
  timeout_milliseconds = 1000,
}

-- cmd key fix - using the kitty keyboard protocol over the csi-u protocol
config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = false
-- make left/right alt keys work
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

config.keys = {
  -- Functionality
  -- INFO: In the Debug Overlay (default: CTRL + SHIFT + L) you can interactively with lua code.
  --
  { key = "p", mods = "CTRL|SHIFT", action = act.ActivateCommandPalette },
  { key = "v", mods = "LEADER", action = act.ActivateCopyMode },

  -- Common
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "LeftArrow", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "RightArrow", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "UpArrow", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "DownArrow", mods = "LEADER", action = act.ActivatePaneDirection("Down") },

  { key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "Q", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },

  { key = "s", mods = "LEADER", action = act.SplitHorizontal({}) }, -- right
  { key = "S", mods = "LEADER", action = act.SplitVertical({}) }, -- down

  { key = "n", mods = "LEADER", action = act.SpawnWindow },

  { key = "t", mods = "LEADER", action = act.SpawnTab("DefaultDomain") },
  { key = "T", mods = "LEADER", action = act.ShowTabNavigator },
  { key = "H", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "L", mods = "LEADER", action = act.ActivateTabRelative(1) },

  { key = "/", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "hash" }) },

  -- Pane actions
  {
    key = "p",
    mods = "LEADER",
    action = act.ActivateKeyTable({ name = "pane_actions", timeout_milliseconds = 2000 }),
  },

  -- Adjust pane size
  {
    key = "a",
    mods = "LEADER",
    action = act.ActivateKeyTable({ name = "adjust_pane_size", one_shot = false }),
  },

  -- Rotate panes
  {
    key = "r",
    mods = "LEADER",
    action = act.ActivateKeyTable({ name = "rotate_panes", one_shot = false }),
  },

  -- Workspaces
  {
    key = "w",
    mods = "LEADER",
    action = act.ActivateKeyTable({ name = "workspaces", timeout_milliseconds = 2000 }),
  },

  -- Custom events
  {
    key = "Enter",
    mods = "LEADER",
    action = act.ActivateKeyTable({ name = "events", timeout_milliseconds = 2000 }),
  },
}

config.key_tables = {
  pane_actions = {
    { key = "f", action = act.TogglePaneZoomState },
    {
      key = "g",
      action = act.PaneSelect({ alphabet = "1234567890", mode = "Activate", show_pane_ids = false }),
    },
    {
      key = "s",
      action = act.PaneSelect({ alphabet = "1234567890", mode = "SwapWithActive", show_pane_ids = false }),
    },
  },

  adjust_pane_size = {
    { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

    { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

    { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

    { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

    { key = "Escape", action = "PopKeyTable" },
  },

  rotate_panes = {

    { key = "h", action = act.RotatePanes("Clockwise") },
    { key = "LeftArrow", action = act.RotatePanes("Clockwise") },

    { key = "l", action = act.RotatePanes("CounterClockwise") },
    { key = "RightArrow", action = act.RotatePanes("CounterClockwise") },

    { key = "Escape", action = "PopKeyTable" },
  },

  events = {
    { key = "o", action = act.EmitEvent("opacity-toggle") },
  },

  workspaces = {
    -- Create new
    {
      key = "n",
      action = act.PromptInputLine({
        description = wezterm.format({
          { Attribute = { Intensity = "Bold" } },
          { Foreground = { AnsiColor = "Fuchsia" } },
          { Text = "Enter name for new workspace" },
        }),
        action = wezterm.action_callback(function(window, pane, line)
          -- line will be `nil` if they hit escape without entering anything
          -- An empty string if they just hit enter
          -- Or the actual line of text they wrote
          if line then
            window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
          end
        end),
      }),
    },

    -- Navigation
    { key = "h", action = act.SwitchWorkspaceRelative(1) },
    { key = "l", action = act.SwitchWorkspaceRelative(-1) },

    -- Open
    { key = "o", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
  },
}

--
-- Hyperlink Rules
--
local hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(
  hyperlink_rules,
  -- detect ripgrep matching results
  {
    regex = [[file://\S+:\d+:\d+]],
    format = "", -- format doesn't work with ripgrep results!
  }
)
config.hyperlink_rules = hyperlink_rules

--
-- Triggers
--

--
wezterm.on("open-uri", function(window, pane, uri)
  local url = wezterm.url.parse(uri)
  if url.scheme == "file" then
    -- open a new window and spawn it!
    local action = act({
      SpawnCommandInNewWindow = {
        args = { "nvim", url.file_path },
      },
    })
    window:perform_action(action, pane)
    -- prevent the default action from opening in a browser
    return false
  end
end)

--
wezterm.on("update-right-status", function(window, pane)
  local key_table = window:active_key_table()
  local workspace = window:active_workspace()

  local status = workspace
  if key_table then
    status = status .. ":" .. key_table
  end
  window:set_right_status(status)
end)

--
local default_background_opacity = 0.75
config.window_background_opacity = default_background_opacity

wezterm.on("opacity-toggle", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if overrides.window_background_opacity == 1.0 then
    overrides.window_background_opacity = default_background_opacity
  else
    overrides.window_background_opacity = 1.0
  end
  window:set_config_overrides(overrides)
end)

--
return config
