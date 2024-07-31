local wezterm = require("wezterm")
local act = wezterm.action
-- local mux = wezterm.mux

local hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(
  hyperlink_rules,
  -- detect ripgrep matching results
  {
    regex = [[file://\S+:\d+:\d+]],
    format = "", -- format doesn't work with ripgrep results!
  }
)

-- toggle opacity
-- TODO: refactor this to
-- local default...
-- config.window_background_opacity = default...
local default_background_opacity = 0.85

wezterm.on("toggle-opacity", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if overrides.window_background_opacity == 1.0 then
    overrides.window_background_opacity = default_background_opacity
  else
    overrides.window_background_opacity = 1.0
  end
  window:set_config_overrides(overrides)
end)

--
-- local config = wezterm.config_builder()
--
local config = {
  default_prog = { "/opt/homebrew/bin/zsh", "--login" },

  -- look & feel
  front_end = "WebGpu",
  webgpu_preferred_adapter = wezterm.gui.enumerate_gpus()[1],
  prefer_egl = true,
  term = "xterm-256color",
  color_scheme = "Muse (terminal.sexy)",
  font = wezterm.font_with_fallback({
    { family = "Anonymous Pro", weight = "Regular", italic = true },
  }),
  font_size = 15.0,
  line_height = 1.05,
  text_background_opacity = 1.0,
  -- disable ligatures for all fonts
  harfbuzz_features = { "calt=0" },

  -- command pallet
  command_palette_font_size = 13,

  -- tab bar
  enable_tab_bar = true,
  use_fancy_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  -- window
  window_decorations = "RESIZE",
  -- window_close_confirmation = "NeverPrompt",
  window_background_opacity = 0.85,
  macos_window_background_blur = 5,
  window_frame = {
    font = wezterm.font({ family = "Anonymous Pro", weight = "Regular", italic = true }),
    font_size = 15.0,
  },
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  },

  -- performance
  enable_scroll_bar = true,
  -- CTRL-SHIFT-K and CMD-K will trigger the ClearScrollback action and discard
  -- the contents of the scrollback buffer.
  scrollback_lines = 3500,

  -- hyperlinks
  hyperlink_rules = hyperlink_rules,

  -- key bindings
  disable_default_key_bindings = false,
  -- make alt keys (left/right) work
  send_composed_key_when_left_alt_is_pressed = false,
  send_composed_key_when_right_alt_is_pressed = false,
  -- cmd key fix - using the kitty keyboard protocol over the csi-u protocol
  enable_kitty_keyboard = true,
  enable_csi_u_key_encoding = false,

  leader = {
    key = "Space",
    mods = "CTRL|ALT|CMD",
    timeout_milliseconds = 1000,
  },

  keys = {
    -- Pane
    { key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
    { key = "s", mods = "LEADER", action = act.SplitHorizontal({}) },
    { key = "v", mods = "LEADER", action = act.SplitVertical({}) },
    { key = "r", mods = "LEADER", action = act.RotatePanes("Clockwise") },
    { key = "R", mods = "LEADER", action = act.RotatePanes("CounterClockwise") },
    { key = "S", mods = "LEADER", action = act.PaneSelect({ mode = "SwapWithActive" }) },

    -- Pane navigation
    { key = "p", mods = "LEADER", action = act.PaneSelect },
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },

    -- Tabs
    { key = "t", mods = "LEADER", action = act.SpawnTab("DefaultDomain") },
    { key = "T", mods = "LEADER", action = act.ShowTabNavigator },
    { key = "Q", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
    { key = "n", mods = "LEADER", action = act.SpawnWindow },
    { key = "H", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "L", mods = "LEADER", action = act.ActivateTabRelative(1) },

    -- Workspaces
    {
      key = "w",
      mods = "LEADER",
      action = act.ActivateKeyTable({ name = "workspaces", timeout_milliseconds = 1000 }),
    },

    -- Custom events
    {
      key = "e",
      mods = "LEADER",
      action = act.ActivateKeyTable({ name = "events", timeout_milliseconds = 1000 }),
    },

    -- Functionality
    -- INFO: In the Debug Overlay (default: CTRL + SHIFT + L) you can interactively with lua code.
    --
    { key = "p", mods = "CTRL|SHIFT", action = act.ActivateCommandPalette },
  },

  key_tables = {

    events = {
      { key = "o", action = act.EmitEvent("toggle-opacity") },
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
  },
}

-- triggers
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

wezterm.on("update-right-status", function(window, pane)
  -- change the content that is displayed in the right side of tab bar
  window:set_right_status(window:active_workspace())
end)

return config
