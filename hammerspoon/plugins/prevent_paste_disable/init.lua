-- Prevent paste disable

-- Some websites disable paste. This plugin adds a
-- hotkey that "types" the contents of the clipboard.

local m = {}

function m.initialize()
  hs.hotkey.bind({"cmd", "ctrl"}, "v", function()
    for c in hs.pasteboard.getContents():gmatch(".") do
      hs.eventtap.keyStroke({}, c)
    end
  end)
end

return m
