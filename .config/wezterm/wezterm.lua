local wezterm = require 'wezterm'
local act = wezterm.action 
local mux = wezterm.mux

local path_dirs = {
  -- homebrew
  '/opt/homebrew/bin',
  '/opt/homebrew/sbin',
  -- os
  '/usr/local/bin',
  '/usr/bin',
  '/bin',
  '/usr/sbin',
  '/sbin',
  -- user
  '/Users/ndm/.local/bin',
  '/Users/ndm/.cargo/bin',
  '/Users/ndm/.golang/bin',
  '/Users/ndm/.go/bin',
}

local hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(
  hyperlink_rules,
  -- detect ripgrep matching results
  {
    regex = [[file://\S+:\d+:\d+]],
    format = '',  -- format doesn't work with ripgrep results!
  }
)

-- local config = wezterm.config_builder()
local config = {
  default_prog = { '/opt/homebrew/bin/zsh', '--login' },

  -- look & feel
  color_scheme = 'Muse (terminal.sexy)',
  font = wezterm.font 'Fira Code',
  font_size = 14.0,
  line_height = 1.1,
  text_background_opacity = 1.0,
  -- disable ligatures
  harfbuzz_features = { 'calt=0' },

  -- command palet
  command_palette_font_size = 16,

  -- tab bar
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,

  -- window
  window_decorations = 'RESIZE',
  -- window_close_confirmation = "NeverPrompt",
  window_background_opacity = 0.9,
  window_frame = {
    font = wezterm.font { family = 'Fira Code', weight = 'Regular' },
  },
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  },

  -- performance
  scrollback_lines = 3500,

  -- env
  set_environment_variables = {
    -- WTF!!!
    -- PATH = os.getenv('PATH'),
    PATH = table.concat(path_dirs, ':'),
  },

  -- hyperlinks
  hyperlink_rules = hyperlink_rules,

  -- key bindings
  disable_default_key_bindings = false,
  leader = { key = 'Space', mods = 'CTRL|ALT|CMD', timeout_milliseconds = 2000 },

  keys = {
    { key = 'p', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },
    {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateKeyTable { name = 'pane', timeout_milliseconds = 1000 },
    },
    {
      key = 'r',
      mods = 'LEADER',
      action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false },
    },
    {
      key = 'w',
      mods = 'LEADER',
      action = act.ActivateKeyTable { name = 'workspaces', timeout_milliseconds = 1000 },
    },
  },

  key_tables = {
    pane = {
      { key = 'w', action = act.CloseCurrentPane { confirm = true } },
      { key = 's', action = act.SplitHorizontal {} },
      { key = 'd', action = act.SplitVertical  {} },
      { key = 'r', action = act.RotatePanes 'Clockwise' },
      { key = 't', action = act.RotatePanes 'CounterClockwise' },

      { key = 'LeftArrow', action = act.ActivatePaneDirection 'Left' },
      { key = 'h', action = act.ActivatePaneDirection 'Left' },
      { key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
      { key = 'l', action = act.ActivatePaneDirection 'Right' },
      { key = 'UpArrow', action = act.ActivatePaneDirection 'Up' },
      { key = 'k', action = act.ActivatePaneDirection 'Up' },
      { key = 'DownArrow', action = act.ActivatePaneDirection 'Down' },
      { key = 'j', action = act.ActivatePaneDirection 'Down' },
    },
   resize_pane = {
      { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 1 } },
      { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },
      { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
      { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },
      { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 1 } },
      { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },
      { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 1 } },
      { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },
      -- cancel the mode by pressing escape
      { key = 'Escape', action = 'PopKeyTable' },
    },
    workspaces = {
      -- create new workspace
      {
        key = 'n',
        action = act.PromptInputLine {
          description = wezterm.format {
            { Attribute = { Intensity = 'Bold' } },
            { Foreground = { AnsiColor = 'Fuchsia' } },
            { Text = 'Enter name for new workspace' },
          },
          action = wezterm.action_callback(function(window, pane, line)
            -- line will be `nil` if they hit escape without entering anything
            -- An empty string if they just hit enter
            -- Or the actual line of text they wrote
            if line then
              window:perform_action(
                act.SwitchToWorkspace {
                  name = line,
                },
                pane
              )
            end
          end),
        },
      },

      { key = 'p', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
      { key = 'w', action = act.SwitchToWorkspace { name = 'default' } },
      { key = 'e', action = act.SwitchToWorkspace { name = 'earth' } },
      { key = 'm', action = act.SwitchToWorkspace { name = 'moon' } },

      { key = 'LeftArrow', action = act.SwitchWorkspaceRelative(1) },
      { key = 'h', action = act.SwitchWorkspaceRelative(1) },
      { key = 'RightArrow', action = act.SwitchWorkspaceRelative(-1) },
      { key = 'l', action = act.SwitchWorkspaceRelative(-1) },
    },
  },
}

-- triggers
wezterm.on('open-uri', function(window, pane, uri)
  local url = wezterm.url.parse(uri)
  if url.scheme == 'file' then
    -- open a new window and spawn it!
    local action = act{
      SpawnCommandInNewWindow={
        args={'hx', url.file_path},
      }
    };
    window:perform_action(action, pane);
    -- prevent the default action from opening in a browser
    return false
  end
end)

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

wezterm.on('update-right-status', function(window, pane)
  -- change the content that is displayed in the right side of tab bar
  window:set_right_status(window:active_workspace())
end)

return config
