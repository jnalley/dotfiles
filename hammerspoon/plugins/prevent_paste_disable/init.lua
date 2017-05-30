-- Prevent paste disable

-- Some websites disable paste. This plugin adds a
-- hotkey that "types" the contents of the clipboard.

local m = {}

function m.initialize()
  hs.hotkey.bind({"cmd", "ctrl"}, "v", function()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
  end)
end

return m
