local appearance = require("macos.appearance")
local rectangle = require("apps.rectangle")

-- Toggle Dark/Light MacOS appearance
hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "F12", appearance.toggle)
-- Move the focused app to the center of the screen, resizing it to two-thirds of the screen size.
-- When the hotkey is pressed again, return the app to its original position.
hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "return", rectangle.toggleCentered)
