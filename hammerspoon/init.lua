-- seed the RNG
math.randomseed(os.time())

-- default log level
hs.logger.defaultLogLevel = "info"

-- disable icons
hs.dockIcon(false)
hs.menuIcon(true)

-- set console colors
hs.console.outputBackgroundColor(hs.drawing.color.ansiTerminalColors.bgBlack)
hs.console.consoleCommandColor(hs.drawing.color.ansiTerminalColors.fgGreen)

-- only reload if a .lua file changed
local function reload(files)
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      hs.reload()
    end
  end
end

local pw = hs.pathwatcher.new(hs.configdir, reload):start()

-- a work-around for websites that disable paste
hs.hotkey.bind({"cmd", "ctrl"}, "v", function()
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

hs.grid.setGrid("2x2")
hs.grid.ui.showExtraKeys = true
hs.hotkey.bind({"alt", "cmd"}, "G", function() hs.grid.show() end)

hs.hints.style = "vimperator"
hs.window.animationDuration = 0

-- window management hotkeys
local function moveToUnit(unit)
  hs.window.focusedWindow():moveToUnit(unit)
end

hs.hotkey.bind({"alt", "cmd"}, "Left",
  hs.fnutils.partial(moveToUnit, hs.layout.left50)
  -- 50% vertical
  -- hs.fnutils.partial(moveToUnit, hs.geometry.unitrect(0,0,0.5,0.5))
)
hs.hotkey.bind({"alt", "cmd"}, "Right",
  hs.fnutils.partial(moveToUnit, hs.layout.right50)
)
hs.hotkey.bind({"alt", "cmd"}, "Up",
  function() hs.window.frontmostWindow():maximize() end
)

-- toggles inhibit of system sleep
hs.hotkey.bind({"cmd", "alt"}, "s", function()
  hs.alert.show(
    hs.caffeinate.toggle("displayIdle") and
    "Sleep disabled" or "Normal sleep restored"
  )
end)

-- cli
-- if not hs.ipc.cliStatus() then
--   hs.ipc.cliInstall()
-- end

-- local hammerspoon = hs.application.open("hammerspoon")
-- hs.timer.doAfter(3, function() print(hammerspoon:bundleID()) end)

hs.loadSpoon("TapCtrlForEscape"):start()

-- done
FadeLogo = hs.loadSpoon("FadeLogo")
FadeLogo.run_time = 0.8
FadeLogo:start()
