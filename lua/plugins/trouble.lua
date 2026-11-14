local M = {}

function M.setup()
  require("trouble").setup({
    focus = true,
    auto_preview = true,
  })

  local map = vim.keymap.set
  map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Workspace diagnostics" })
  map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
  map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", { desc = "Symbols outline" })
  map(
    "n",
    "<leader>xl",
    "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
    { desc = "LSP definitions/references" }
  )
  map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix list" })
  map("n", "<leader>xL", "<cmd>Trouble loclist toggle<CR>", { desc = "Location list" })
end

return M
