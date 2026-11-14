local map = vim.keymap.set

-- Double <Esc> leaves terminal mode; a single <Esc> still reaches the program
-- (Claude Code, lazygit, fzf, ... all use it).
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Navigate vim panes better
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper split" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower split" })
map("n", "<C-h>", "<C-w>h", { desc = "Focus left split" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right split" })

map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
