vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

-- Better terminal mode exit
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true

vim.diagnostic.config({
  virtual_text = {},
  signs = true,
  update_in_insert = false,
})

-- C++ header/implementation file switching
local cpp_switch = require('cpp-switch')
vim.keymap.set('n', '<leader>a', cpp_switch.switch_cpp_header, { desc = "Switch between .cpp and .h files" })

-- Completion popup highlight overrides (match telescope colours)
vim.api.nvim_set_hl(0, "CmpBorder",   { link = "TelescopeBorder" })
vim.api.nvim_set_hl(0, "CmpNormal",   { link = "TelescopeNormal" })
vim.api.nvim_set_hl(0, "CmpSel",      { link = "TelescopeSelection" })
vim.api.nvim_set_hl(0, "PmenuSbar",   { link = "TelescopePreviewBorder" })
vim.api.nvim_set_hl(0, "PmenuThumb",  { link = "TelescopeBorder" })
