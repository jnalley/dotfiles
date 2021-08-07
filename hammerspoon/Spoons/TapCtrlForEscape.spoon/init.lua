local obj = {}
obj.__index = obj

obj.name = "TapCtrlForEscape"
obj.version = "0.1"
obj.author = "Jon Nalley <code@bluebot.org>"
obj.homepage = "https://github.com/jnalley/dotfiles"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.logger = hs.logger.new("TapCtrlForEscape")
obj.menubar = nil

local function enable_secure_mode_indicator()
  if obj.menubar ~= nil then
    return
  end
  obj.menubar = hs.menubar.new()
  obj.menubar:setTooltip("Secure input is inhibiting TapCtrlForEscape")
  obj.menubar:setIcon(
    hs.image.imageFromPath(
      hs.spoons.resourcePath("keyboard.png")):setSize({h=22,w=24}
    ), false
  )
end

local function disable_secure_mode_indicator()
  if obj.menubar ~= nil then
    obj.menubar:delete()
    obj.menubar = nil
  end
end

local function abort()
  return (
      obj.non_modifier_tap:isEnabled() and
      obj.non_modifier_tap:stop() and true
    )
end

local function ctrl_key_up(evt)
  return next(evt:getFlags()) == nil and evt:getProperty(
    hs.eventtap.event.properties.keyboardEventKeycode
  ) == 62
end

local function modifier_handler(evt)
  -- if hs.eventtap.isSecureInputEnabled() then
  --   obj.logger.w("Secure input is enabled - TapCtrlForEscape will fail!")
  --   enable_secure_mode_indicator()
  -- else
  --   disable_secure_mode_indicator()
  -- end
  if evt:getFlags():containExactly({"ctrl"}) and not hs.eventtap.isSecureInputEnabled() then
    obj.logger.d("ESCAPE pending")
    obj.non_modifier_tap:start()
  elseif abort() and ctrl_key_up(evt) then
    obj.logger.d("sending ESCAPE")
    hs.eventtap.keyStroke({}, "ESCAPE", 3000)
  end
end

function obj:init()
end

function obj:start()
  -- isEnabled() is used as a "flag" for a pending ESCAPE
  self.non_modifier_tap = hs.eventtap.new(
    {hs.eventtap.event.types.keyDown},
    function() obj.non_modifier_tap:stop() end
  )

  -- modifier key presses
  self.modifier_tap = hs.eventtap.new(
    {hs.eventtap.event.types.flagsChanged}, modifier_handler
  ):start()

  return self
end

function obj:stop()
  for tap in ipairs({"non_modifier_tap", "modifier_tap"}) do
    if self[tap] ~= nil then
      self[tap]:stop()
    end
    self[tap] = nil
  end
end

return obj
