local vim = vim
local o = vim.opt

require("disabled")

-- set leader to SPACE
vim.g.mapleader = " "

-- tabs/spaces defaults
o.expandtab = true
o.shiftwidth = 2
o.softtabstop = 2
o.tabstop = 2

o.background = "dark"
o.colorcolumn = "80"
o.diffopt = "vertical"
o.fillchars = { vert="│", fold="‒" }
o.foldmethod = "marker"
o.hidden = true
o.history = 500
o.ignorecase = true
o.infercase = true
o.joinspaces = false
o.lazyredraw = true
o.list = true
o.listchars = {
  tab = "▸ ",
  extends ="❯",
  precedes ="❮",
  nbsp =  "⌴",
  trail = "•"
}
o.matchpairs:append("<:>")
o.mouse = ""
o.number = false
o.numberwidth = 5
o.shortmess:append("I", "c")
o.showbreak = "↪"
o.showmode = false
o.showtabline = 1
o.smartcase = true
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.ttimeout = true
o.ttimeoutlen = -1
o.virtualedit = "block"
o.whichwrap = "b,s,h,l,<,>,[,]"
o.winminheight = 0
o.wrap = false
o.wildignore:append {
  "*.a",
  "*.bak",
  "*.gem",
  "*.o",
  "*.obj",
  "*.pyc",
  "*/.git/*",
  "*~"
}
