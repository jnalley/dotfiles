-- disable dock icon
-- hs.dockIcon(false)

-- disable window animations
hs.window.animationDuration = 0

local function get_focused_window()
  local w = {}
  w.win =  hs.window.focusedWindow()
  w.frame = w.win:frame()
  w.screen = w.win:screen()
  w.max = w.screen:frame()
  return w
end

-- resize window to left half of screen
hs.hotkey.bind({"cmd", "alt"}, "Left", function()
  w = get_focused_window()
  w.frame.x = w.max.x
  w.frame.y = w.max.y
  w.frame.w = w.max.w / 2
  w.frame.h = w.max.h
  w.win:setFrame(w.frame)
end)

-- resize window to right half of screen
hs.hotkey.bind({"cmd", "alt"}, "Right", function()
  w = get_focused_window()
  w.frame.x = w.max.x + (w.max.w / 2)
  w.frame.y = w.max.y
  w.frame.w = w.max.w / 2
  w.frame.h = w.max.h
  w.win:setFrame(w.frame)
end)

-- resize window to full screen
hs.hotkey.bind({"cmd", "alt"}, "Up", function()
  w = get_focused_window()
  w.frame.x = w.max.x
  w.frame.y = w.max.y
  w.frame.w = w.max.w
  w.frame.h = w.max.h
  w.win:setFrame(w.frame)
end)

-- prevent paste disable
hs.hotkey.bind({"cmd", "ctrl"}, "v", function()
  for c in hs.pasteboard.getContents():gmatch(".") do
    hs.eventtap.keyStroke({}, c)
  end
end)

-- prevent system sleep on A/C
-- hs.caffeinate.set("system", true, false)

-- Send'ESCAPE' when 'CTRL' is pressed and released. Other 'CTRL' combinations
-- work as expected.
--
-- Based on: https://gist.github.com/zcmarine/f65182fe26b029900792fa0b59f09d7f

local send_escape = false
local prev_modifiers = {}
local non_modifier_tap = nil

-- Tap for non-modifier keyDown events (only enabled subsequent to CTRL
-- being pressed)
non_modifier_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown},
  function()
    send_escape = false
    if non_modifier_tap:isEnabled() then
      non_modifier_tap:stop()
    end
    return false
  end)

local function modifier_handler(evt)
  -- Modifiers that caused the event
  local curr_modifiers = evt:getFlags()
  local modifier = next(curr_modifiers, nil)
  local single_modifier = nil == next(curr_modifiers, modifier)
  local no_prev_modifiers = nil == next(prev_modifiers, nil)

  if modifier == 'ctrl' and single_modifier and no_prev_modifiers then
    -- We need this here because we might have had additional modifiers, which
    -- we don't want to lead to an escape, e.g. [Ctrl + Cmd] —> [Ctrl] —> [ ]
    send_escape = true
    -- Don't send ESCAPE if a non-modifier is pressed subsequent to CTRL.
    non_modifier_tap:start()
  elseif not modifier and prev_modifiers["ctrl"] and send_escape then
    send_escape = false
    hs.eventtap.keyStroke({}, "ESCAPE", 2000)
  else
    send_escape = false
  end
  prev_modifiers = curr_modifiers
end

-- Call the modifier_handler function anytime
-- a modifier key is pressed or released.
hs.eventtap.new({hs.eventtap.event.types.flagsChanged},
  modifier_handler):start()

hs.alert.show("Hammerspoon Loaded")
