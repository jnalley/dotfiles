local m = {}

local path = os.getenv("HOME") .. "/.hammerspoon/"

local function reload(files)
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      hs.reload()
    end
  end
end

function m.initialize()
  m.reload_watcher = hs.pathwatcher.new(path, reload):start()
end

return m
