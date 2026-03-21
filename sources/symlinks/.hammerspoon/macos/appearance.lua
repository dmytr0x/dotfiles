local M = {}

local function setAppearance(dark)
  hs.osascript.applescript(string.format([[
    tell application "System Events"
      tell appearance preferences
        set dark mode to %s
      end tell
    end tell
  ]], dark and "true" or "false"))
end

function M.toggle()
  local ok, result = hs.osascript.applescript([[
    tell application "System Events"
      tell appearance preferences
        return dark mode
      end tell
    end tell
  ]])

  if ok then
    local newMode = not result
    setAppearance(newMode)
    hs.alert.show(newMode and "Dark" or "Light")
  else
    hs.alert.show("Could not read appearance")
  end
end

return M
