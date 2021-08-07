local obj = {}
obj.__index = obj

obj.name = "WindowManagement"
obj.version = "0.1"
obj.author = "Jon Nalley <code@bluebot.org>"
obj.homepage = "https://github.com/jnalley/dotfiles"
obj.license = "MIT - https://opensource.org/licenses/MIT"

local function moveToUnit(unit)
  hs.window.focusedWindow():moveToUnit(unit)
end

local function bind_hotkey(action, modifiers, key)
end

function obj:init()
  hs.grid.setGrid("2x2")
  hs.grid.ui.showExtraKeys = true
  hs.hotkey.bind({"alt", "cmd"}, "G", function() hs.grid.show() end)
end

function obj:bindHotKeys(mapping)
  for _,action in ipairs{"left", "right", "maximize"} do
    if mapping[action] ~= nil then
      bind_hotkey(
        (action:gsub("^%l", string.upper)),
        mapping[action][1],
        mapping[action][2]
      )
    end
  end
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
