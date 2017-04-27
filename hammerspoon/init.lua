-- load plugins
require("plugins")

-- weather
require("hs-weather").start{ geolocation = true, units = "F" }

-- disable icons
hs.dockIcon(false)
hs.menuIcon(false)

-- disable window animations
hs.window.animationDuration = 0

-- done
hs.alert.show("Hammerspoon loaded")
