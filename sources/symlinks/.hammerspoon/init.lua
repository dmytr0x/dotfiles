local appearance = require("macos.appearance")
local rectangle = require("apps.rectangle")
local leaderkey = require("helpers.leaderkey")

local hyper = { "control", "option", "command" }

-- Toggle Dark/Light MacOS appearance
hs.hotkey.bind(hyper, "F12", appearance.toggle)
-- Move the focused app to the center of the screen, resizing it to two-thirds of the screen size.
-- When the hotkey is pressed again, return the app to its original position.
hs.hotkey.bind(hyper, "return", rectangle.toggleCentered)

-- Open or focus on popular applications
hs.hotkey.bind(hyper, "o", leaderkey.create({
  a = function() hs.application.open("Codex") end,
  t = function() hs.application.open("Ghostty") end,
  e = function() hs.application.open("Zed") end,
  n = function() hs.application.open("Obsidian") end,
}))
