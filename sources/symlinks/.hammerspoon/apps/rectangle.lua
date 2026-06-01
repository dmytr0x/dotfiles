local M = {}

-- Stores the pre-centered frame per app so we can restore it on toggle off.
local savedFrames = {}

function M.toggleCentered()
  local app = hs.application.frontmostApplication()
  if not app then
    hs.alert.show("no frontmost app")
    return
  end

  local appId = app:bundleID() or app:name()
  if not appId then
    hs.alert.show("no app id")
    return
  end

  local win = app:focusedWindow()
  if not win then
    hs.alert.show("no focused window")
    return
  end

  local saved = savedFrames[appId]
  if saved then
    win:setFrame(saved)
    savedFrames[appId] = nil
  else
    savedFrames[appId] = win:frame()
    -- Center at two-thirds of the width and full height of the screen the
    -- window currently lives on, so it never jumps to another monitor.
    local screenFrame = win:screen():frame()
    local w = screenFrame.w * 2 / 3
    win:setFrame({
      x = screenFrame.x + (screenFrame.w - w) / 2,
      y = screenFrame.y,
      w = w,
      h = screenFrame.h,
    })
  end
end

return M
