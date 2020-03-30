-- Send 'ESCAPE' when 'CTRL' is pressed and released.
-- Other 'CTRL' combinations work as expected.
--
-- Originally based on:
--   https://gist.github.com/zcmarine/f65182fe26b029900792fa0b59f09d7f
--
-- NOTE: This plugin depends on being able to monitor the state of non-modifier
-- keys.  Mac OS X has a "Secure Input Mode" that prevents applications from
-- monitoring keyboard input when this mode is enabled.
-- See:
-- https://wiki.keyboardmaestro.com/Troubleshooting#Secure_Input_Mode
-- https://smilesoftware.com/textexpander/secureinput

local m = {}

--[[
m.secure_input_menu_bar = hs.menubar.new()
m.secure_input_menu_bar:setIcon(
  hs.image.imageFromName("NSCaution"):setSize({w=16,h=16})
)
m.secure_input_menu_bar:setTooltip("Secure input mode enabled!")
m.secure_input_menu_bar:returnToMenuBar()
m.secure_input_menu_bar:removeFromMenuBar()
--]]

local CTRL = hs.eventtap.event.rawFlagMasks["control"]
local RIGHT_CTRL = hs.eventtap.event.rawFlagMasks["deviceRightControl"]
local NON_COALESCED = hs.eventtap.event.rawFlagMasks["nonCoalesced"]

-- raw flags that are set for internal keyboard
local BUILTIN = CTRL | RIGHT_CTRL | NON_COALESCED

local function abort()
  if hs.eventtap.isSecureInputEnabled() then
    hs.alert.show("Secure input is enabled - tap_ctrl_for_escape will fail!")
  end
  return m.non_modifier_tap:isEnabled() and m.non_modifier_tap:stop() and true
end

local function ctrl_key_up(evt)
  return next(evt:getFlags()) == nil and evt:getProperty(
    hs.eventtap.event.properties.keyboardEventKeycode
  ) == 62
end

local function modifier_handler(evt)
  if evt:rawFlags() == BUILTIN and evt:getFlags():containExactly({"ctrl"}) then
    hs.alert.show("PENDING")
    m.non_modifier_tap:start() -- ESCAPE pending
  elseif abort() and ctrl_key_up(evt) then
    hs.alert.show("SENDING")
    hs.eventtap.keyStroke({}, "ESCAPE", 3000)
  end
end

function m.initialize()
  -- isEnabled() is used as a "flag" for a pending ESCAPE
  m.non_modifier_tap = hs.eventtap.new(
    {hs.eventtap.event.types.keyDown},
    function() m.non_modifier_tap:stop() end
  )

  m.non_modifier_tap:stop()

  -- modifier key presses
  m.modifier_tap = hs.eventtap.new(
    {hs.eventtap.event.types.flagsChanged}, modifier_handler
  ):start()
end

return m
