-- Plugin loader

local name, path = table.unpack{...}

path = path:match("(.*[/\\])")

local _, dirobj = hs.fs.dir(path)

repeat
  local entry = dirobj:next(path)
  if entry == nil then break end
  if entry:match('^[^%.]') and hs.fs.attributes(path .. '/' .. entry, "mode") == 'directory' then
    local m = require('plugins.' .. entry)
    if type(m.initialize) == "function" then
      m.initialize()
      m.initialize = nil
    end
  end
until false

dirobj:close()

collectgarbage()
