local M = {}

local toggledApps = {}

local function runRectangle(action)
  hs.task.new("/usr/bin/open", nil, {
    "-g",
    "rectangle-pro://execute-action?name=" .. action,
  }):start()
end

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

  if toggledApps[appId] then
    runRectangle("restore")
    toggledApps[appId] = nil
  else
    runRectangle("center-two-thirds")
    toggledApps[appId] = true
  end
end

return M
