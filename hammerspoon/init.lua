-- load plugins
require("plugins")

-- disable icons
hs.dockIcon(false)
hs.menuIcon(false)

-- disable window animations
hs.window.animationDuration = 0

-- done
hs.alert.show("Hammerspoon loaded")
