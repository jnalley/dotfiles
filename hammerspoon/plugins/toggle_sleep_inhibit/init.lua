-- Toggles inhibit of system sleep while on A/C

local m = {}

function m.initialize()
  hs.hotkey.bind({"cmd", "alt"}, "s", function()
    local inhibit = hs.caffeinate.toggle("displayIdle")
    hs.alert.show(inhibit and
      "Sleep disabled while powered" or
      "Normal sleep restored")
  end)
end

return m
