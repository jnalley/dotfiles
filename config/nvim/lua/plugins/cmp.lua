local cmp = require "cmp"

vim.o.completeopt = 'menuone,noselect'

cmp.setup {
  mapping = {
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  sources = {
    { name = "buffer" },
    { name = "nvim_lsp" },
  },
}
