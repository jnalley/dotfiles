-- Send 'ESCAPE' when 'CTRL' is pressed and released.
-- Other 'CTRL' combinations work as expected.
--
-- Originally based on:
--   https://gist.github.com/zcmarine/f65182fe26b029900792fa0b59f09d7f

local m = {}

local function abort()
  return m.non_modifier_tap:isEnabled() and m.non_modifier_tap:stop() and true
end

local function ctrl_key_up(evt)
  return next(evt:getFlags()) == nil and evt:getProperty(
    hs.eventtap.event.properties.keyboardEventKeycode
  ) == 62
end

local function modifier_handler(evt)
  if evt:getFlags():containExactly({"ctrl"}) then
    m.non_modifier_tap:start() -- ESCAPE pending
  elseif abort() and ctrl_key_up(evt) then
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
