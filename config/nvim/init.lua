require "options"
require "keymaps"

local icons = {"kyazdani42/nvim-web-devicons", opt = true}

require("util").plugins{
  {"christoomey/vim-tmux-navigator"},
  {"Murtaza-Udaipurwala/gruvqueen"},
  {"b3nj5m1n/kommentary"},
  {"folke/trouble.nvim", requires = icons},
  {"hoob3rt/lualine.nvim", requires = icons},
  {"justinmk/vim-dirvish"},
  {'neovim/nvim-lspconfig'},
  {"neovim/nvim-lspconfig"},
  {"hrsh7th/nvim-cmp", requires = {"hrsh7th/cmp-buffer"}},
  {"hrsh7th/cmp-nvim-lsp"},
  {"tpope/vim-characterize"},
  {"tpope/vim-fugitive"},
  {"tpope/vim-repeat"},
  {"tpope/vim-surround"},
  {"tpope/vim-unimpaired"},
}
