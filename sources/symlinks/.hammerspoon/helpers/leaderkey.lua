local M = {}

-- Create a leader key that waits for a follow-up keypress.
-- Uses hs.eventtap (created fresh each invocation) to match raw key codes,
-- so the follow-up key works regardless of held modifiers.
-- Automatically times out after `timeout` seconds (default 3) to avoid leaking
-- an active eventtap when no follow-up key is pressed.
function M.create(keymap, timeout)
  timeout = timeout or 3
  local codeMap = {}
  for key, fn in pairs(keymap) do
    codeMap[hs.keycodes.map[key]] = fn
  end
  local escapeCode = hs.keycodes.map["escape"]
  local tap
  local timer

  return function()
    if tap then tap:stop() end
    if timer then timer:stop() end
    tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
      local fn = codeMap[event:getKeyCode()]
      tap:stop(); tap = nil
      if timer then timer:stop(); timer = nil end
      if fn then fn() end
      return fn ~= nil or event:getKeyCode() == escapeCode
    end)
    tap:start()
    timer = hs.timer.doAfter(timeout, function()
      if tap then
        tap:stop()
        tap = nil
      end
    end)
  end
end

return M
