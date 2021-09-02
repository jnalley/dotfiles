local m = {}

local function _keymap(mode, combo, mapping, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, combo, mapping, options)
end

function m.partial(f, ...)
  local args = {...}
  return function(...) return f(unpack(args), ...) end
end

function m.plugins(plugins)
  require("packer").startup(function(use)
    use "wbthomason/packer.nvim"
    for _, args in ipairs(plugins) do
      local plugin = args[1]
      local cfg = plugin:gsub(
        "(.*/)(.*)","%2"
      ):gsub("^nvim%-",""):gsub("%.nvim$",""):gsub("-","_")
      local path = string.format(
        "%s/lua/plugins/%s.lua", vim.fn.stdpath("config"), cfg
      )
      if vim.loop.fs_stat(path) then
        args["config"] = string.format([[require("plugins/%s")]], cfg)
      end
      use(args)
    end
  end)
end

m.noremap  = m.partial(_keymap, "")
m.nnoremap = m.partial(_keymap, "n")
m.vnoremap = m.partial(_keymap, "v")

return m
