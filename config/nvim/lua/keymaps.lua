local u = require("util")

-- choose buffer
u.nnoremap("<leader><tab>", ":buffers<cr>:buffer<space>")

-- clear highlighted search
u.nnoremap("<cr>", ":nohlsearch<cr><cr>")

-- visual shifting (does not exit Visual mode)
u.vnoremap("<", "<gv")
u.vnoremap(">", ">gv")

-- wrapped lines goes down/up to next row, rather than next line in file.
u.nnoremap("j", "gj")
u.nnoremap("k", "gk")

-- execute default register.
u.nnoremap("Q", "@q")

-- edit config
u.nnoremap("<leader>v", ":e! $MYVIMRC<cr>")

-- auto indent pasted text
u.nnoremap("p", "gp=`]")
u.nnoremap("P", "gP=`]")

-- previous buffer
u.nnoremap("<leader><leader>", ":b#<cr>")

-- format buffer
u.nnoremap(
  "<leader>ff", ":lua vim.lsp.buf.formatting_seq_sync()<cr>",
  {silent = true}
)
