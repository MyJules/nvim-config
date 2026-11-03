vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.termguicolors = true
opt.background = "dark"
opt.number = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 6
opt.showmode = false
opt.laststatus = 3
opt.showtabline = 0
opt.statusline = " %f %m%r%=%y  %l:%c "
opt.mouse = "a"
opt.fillchars:append({ eob = " " })
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250

vim.opt.swapfile = false
-- Load trusted project-local .nvim.lua files (Neovim prompts before first use).
vim.opt.exrc = true

-- Better terminal mode exit
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- Navigate vim panes better
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Focus upper split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Focus lower split" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Focus left split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Focus right split" })

vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  update_in_insert = false,
})

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
