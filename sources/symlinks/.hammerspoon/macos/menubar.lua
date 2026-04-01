local M = {}

function M.toggle()
  local ok, result = hs.osascript.applescript([[
    tell application "System Events"
      tell dock preferences
        set newState to not autohide menu bar
        set autohide menu bar to newState
        return newState
      end tell
    end tell
  ]])
end

return M
