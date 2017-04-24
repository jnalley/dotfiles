-- Shortcuts for resizing and positioning windows

local m = {}

local function get_focused_window()
  local w = {}
  w.win =  hs.window.focusedWindow()
  w.frame = w.win:frame()
  w.screen = w.win:screen()
  w.max = w.screen:frame()
  return w
end

function m.initialize()
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
end

return m
