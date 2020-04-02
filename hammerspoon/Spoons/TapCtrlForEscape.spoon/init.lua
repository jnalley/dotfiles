-- Send 'ESCAPE' when 'CTRL' is pressed and released.
-- Other 'CTRL' combinations work as expected.
--
-- Originally based on:
--   https://gist.github.com/zcmarine/f65182fe26b029900792fa0b59f09d7f
--
-- NOTE: This plugin depends on being able to monitor the state of non-modifier
-- keys.  Mac OS X has a "Secure Input Mode", used in password dialogs, that
-- prevents applications from monitoring keyboard input.  When secure input
-- mode is enabled, a red keyboard icon will be displayed in the menubar.
--
-- See:
-- https://wiki.keyboardmaestro.com/Troubleshooting#Secure_Input_Mode
-- https://smilesoftware.com/textexpander/secureinput

local obj = {}

obj.name = "TapCtrlForEscape"
obj.version = "0.1"
obj.author = "Jon Nalley <code@bluebot.org>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.menubar = nil

local CTRL = hs.eventtap.event.rawFlagMasks["control"]
local RIGHT_CTRL = hs.eventtap.event.rawFlagMasks["deviceRightControl"]
local NON_COALESCED = hs.eventtap.event.rawFlagMasks["nonCoalesced"]

-- raw flags that are set for internal keyboard
local BUILTIN = CTRL | RIGHT_CTRL | NON_COALESCED

local function ctrl_key_up(evt)
  return next(evt:getFlags()) == nil and evt:getProperty(
    hs.eventtap.event.properties.keyboardEventKeycode
  ) == 62
end

local function abort()
  if hs.eventtap.isSecureInputEnabled() then
    enable_secure_mode_indicator()
  else
    disable_secure_mode_indicator()
  end
  return obj.non_modifier_tap:isEnabled() and obj.non_modifier_tap:stop() and true
end

local function modifier_handler(evt)
  -- skip events for external keyboard
  if evt:rawFlags() ~= BUILTIN then
    return
  end

  if evt:getFlags():containExactly({"ctrl"}) then
    obj.non_modifier_tap:start() -- ESCAPE pending
  elseif abort() and ctrl_key_up(evt) then
    hs.eventtap.keyStroke({}, "ESCAPE", 3000)
  end
end

function obj.init()
end

function obj.enable_secure_mode_indicator()
  obj.menubar = hs.menubar.new()
  obj.menubar:setTooltip("Secure input is inhibiting TapCtrlForEscape")
  obj.menubar:setIcon(
    hs.image.imageFromPath(
      hs.spoons.resourcePath("keyboard.png")):setSize({h=22,w=24}
    ), false
  )
end

function obj.disable_secure_mode_indicator()
  if obj.menubar then
    obj.menubar:delete()
    obj.menubar = nil
  end
end

--- TapCtrlForEscape:start()
--- Method
--- Starts TapCtrlForEscape
---
--- Parameters:
---  * None
---
--- Returns:
---  * The TapCtrlForEscape object
function obj.start()
  -- isEnabled() is used as a "flag" for a pending ESCAPE
  obj.non_modifier_tap = hs.eventtap.new(
    {hs.eventtap.event.types.keyDown},
    function() obj.non_modifier_tap:stop() end
  )

  -- modifier key presses
  obj.modifier_tap = hs.eventtap.new(
    {hs.eventtap.event.types.flagsChanged}, modifier_handler
  ):start()

  return obj
end

--- TapCtrlForEscape:stop()
--- Method
--- Stops TapCtrlForEscape
---
--- Parameters:
---  * None
---
--- Returns:
---  * The TapCtrlForEscape objectini
function obj.stop()
  obj.disable_secure_mode_indicator()
  obj.non_modifier_tap:stop()
  obj.modifier_tap:stop()
end

return obj
