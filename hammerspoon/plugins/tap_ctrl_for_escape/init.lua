-- Send 'ESCAPE' when 'CTRL' is pressed and released.
-- Other 'CTRL' combinations work as expected.
--
-- Based on: https://gist.github.com/zcmarine/f65182fe26b029900792fa0b59f09d7f

local m = {}

m.send_escape = false
m.prev_modifiers = {}

local function non_modifier_handler()
  m.send_escape = false
  if m.non_modifier_tap:isEnabled() then
    m.non_modifier_tap:stop()
  end
  return false
end

local function modifier_handler(evt)
  -- Modifiers that caused the event
  local curr_modifiers = evt:getFlags()
  local modifier = next(curr_modifiers, nil)
  local single_modifier = nil == next(curr_modifiers, modifier)
  local no_prev_modifiers = nil == next(m.prev_modifiers, nil)

  if modifier == 'ctrl' and single_modifier and no_prev_modifiers then
    -- We need this here because we might have had additional modifiers, which
    -- we don't want to lead to an escape, e.g. [Ctrl + Cmd] —> [Ctrl] —> [ ]
    m.send_escape = true
    -- Don't send ESCAPE if a non-modifier is pressed subsequent to CTRL.
    m.non_modifier_tap:start()
  elseif not modifier and m.prev_modifiers["ctrl"] and m.send_escape then
    m.send_escape = false
    hs.eventtap.keyStroke({}, "ESCAPE", 2000)
  else
    m.send_escape = false
  end
  m.prev_modifiers = curr_modifiers
end

function m.initialize()
  -- Tap for non-modifier keyDown events (only enabled subsequent to CTRL
  -- being pressed)
  m.non_modifier_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown},
    non_modifier_handler)

  -- Call the modifier_handler function when a modifier
  -- key is pressed or released.
  m.modifier_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged},
    modifier_handler):start()
end

return m
