local map = vim.keymap.set

-- Double <Esc> leaves terminal mode; a single <Esc> still reaches the program
-- (Claude Code, lazygit, fzf, ... all use it).
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
-- That mapping makes a single <Esc> wait 'timeoutlen' before the program gets it;
-- use a short timeout while in terminal mode so it isn't a 1 s lag.
vim.api.nvim_create_autocmd("TermEnter", {
  group = vim.api.nvim_create_augroup("TerminalEscTimeout", { clear = true }),
  callback = function()
    local saved = vim.o.timeoutlen
    vim.o.timeoutlen = 200
    vim.api.nvim_create_autocmd("TermLeave", {
      group = "TerminalEscTimeout",
      once = true,
      callback = function()
        vim.o.timeoutlen = saved
      end,
    })
  end,
})

-- Navigate vim panes better
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper split" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower split" })
map("n", "<C-h>", "<C-w>h", { desc = "Focus left split" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right split" })

map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
