-- seed the RNG
math.randomseed(os.time())

-- default log level
hs.logger.defaultLogLevel = 'info'

-- load plugins
require("plugins")

-- weather
-- require("hs-weather").start{ geolocation = true, units = "F" }

-- disable icons
hs.dockIcon(false)
hs.menuIcon(false)

-- disable window animations
hs.window.animationDuration = 0

-- cli
-- if not hs.ipc.cliStatus() then
--   hs.ipc.cliInstall()
-- end

-- done
hs.alert.show("Hammerspoon loaded")
