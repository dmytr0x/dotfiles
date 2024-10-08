--
-- Source: wezterm show-keys --lua
--
local wezterm = require("wezterm")
local act = wezterm.action

return {
  keys = {
    {
      key = "B",
      mods = "LEADER",
      action = act.PaneSelect({ alphabet = "", mode = "SwapWithActive", show_pane_ids = false }),
    },
    { key = "P", mods = "CTRL", action = act.ActivateCommandPalette },
    { key = "Z", mods = "CTRL", action = act.TogglePaneZoomState },
    {
      key = "b",
      mods = "LEADER",
      action = act.PaneSelect({ alphabet = "", mode = "Activate", show_pane_ids = false }),
    },
    {
      key = "o",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "workspaces",
        one_shot = true,
        prevent_fallback = false,
        replace_current = false,
        timeout_milliseconds = 1000,
        until_unknown = false,
      }),
    },
    {
      key = "w",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "tab",
        one_shot = true,
        prevent_fallback = false,
        replace_current = false,
        timeout_milliseconds = 1000,
        until_unknown = false,
      }),
    },
  },

  key_tables = {
    copy_mode = {
      { key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      { key = "Tab", mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
      { key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },
      { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
      { key = "Space", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
      { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
      { key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      { key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
      { key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
      { key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
      { key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
      { key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
      { key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
      { key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
      { key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
      { key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      { key = "O", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      { key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = "T", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      { key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
      { key = "b", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
      { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
      { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
      { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
      { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
      { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
      { key = "f", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
      { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
      { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
      { key = "g", mods = "CTRL", action = act.CopyMode("Close") },
      { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
      { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
      { key = "m", mods = "ALT", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
      { key = "q", mods = "NONE", action = act.CopyMode("Close") },
      { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
      { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
      { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
      { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      {
        key = "y",
        mods = "NONE",
        action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
      },
      { key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
      { key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
      { key = "End", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = "Home", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      { key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "LeftArrow", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
      { key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
      { key = "RightArrow", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
      { key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
    },

    search_mode = {
      { key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
      { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
      { key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
      { key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
      { key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
      { key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
      { key = "PageUp", mods = "NONE", action = act.CopyMode("PriorMatchPage") },
      { key = "PageDown", mods = "NONE", action = act.CopyMode("NextMatchPage") },
      { key = "UpArrow", mods = "NONE", action = act.CopyMode("PriorMatch") },
      { key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
    },

    tab = {
      { key = "N", mods = "NONE", action = act.SpawnWindow },
      { key = "Q", mods = "NONE", action = act.CloseCurrentTab({ confirm = true }) },
      { key = "T", mods = "NONE", action = act.RotatePanes("CounterClockwise") },
      { key = "h", mods = "NONE", action = act.ActivatePaneDirection("Left") },
      { key = "j", mods = "NONE", action = act.ActivatePaneDirection("Down") },
      { key = "k", mods = "NONE", action = act.ActivatePaneDirection("Up") },
      { key = "l", mods = "NONE", action = act.ActivatePaneDirection("Right") },
      { key = "n", mods = "NONE", action = act.SpawnTab("DefaultDomain") },
      { key = "q", mods = "NONE", action = act.CloseCurrentPane({ confirm = true }) },
      { key = "s", mods = "NONE", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
      { key = "t", mods = "NONE", action = act.RotatePanes("Clockwise") },
      { key = "v", mods = "NONE", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
      { key = "w", mods = "NONE", action = act.ShowTabNavigator },
      { key = "LeftArrow", mods = "NONE", action = act.ActivatePaneDirection("Left") },
      { key = "RightArrow", mods = "NONE", action = act.ActivatePaneDirection("Right") },
      { key = "UpArrow", mods = "NONE", action = act.ActivatePaneDirection("Up") },
      { key = "DownArrow", mods = "NONE", action = act.ActivatePaneDirection("Down") },
    },

    workspaces = {
      { key = "h", mods = "NONE", action = act.SwitchWorkspaceRelative(1) },
      { key = "l", mods = "NONE", action = act.SwitchWorkspaceRelative(-1) },
      {
        key = "n",
        mods = "NONE",
        action = act.PromptInputLine({
          action = { EmitEvent = "user-defined-0" },
          description = "\u{1b}(B\u{1b}[0;1m\u{1b}[95mEnter\u{20}name\u{20}for\u{20}new\u{20}workspace\u{1b}(B\u{1b}[0m",
        }),
      },
      { key = "o", mods = "NONE", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
      { key = "LeftArrow", mods = "NONE", action = act.SwitchWorkspaceRelative(1) },
      { key = "RightArrow", mods = "NONE", action = act.SwitchWorkspaceRelative(-1) },
    },
  },
}
