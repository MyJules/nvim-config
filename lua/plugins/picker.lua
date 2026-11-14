-- Fuzzy finding with Snacks.picker (configured in plugins/dashboard.lua, where
-- snacks is set up). Needs ripgrep for text search.
local M = {}

function M.setup()
  local picker = Snacks.picker
  local map = vim.keymap.set
  map("n", "<leader>ff", function() picker.files() end, { desc = "Find files" })
  map("n", "<leader>fg", function() picker.grep() end, { desc = "Search text" })
  map({ "n", "x" }, "<leader>fw", function() picker.grep_word() end, { desc = "Search word/selection" })
  map("n", "<leader>fb", function() picker.buffers() end, { desc = "Find open buffers" })
  map("n", "<leader>fh", function() picker.help() end, { desc = "Search help" })
  map("n", "<leader>fd", function() picker.diagnostics() end, { desc = "Workspace diagnostics" })
  map("n", "<leader>fr", function() picker.lsp_references() end, { desc = "LSP references" })
  map("n", "<leader>fs", function() picker.lsp_symbols() end, { desc = "Document symbols" })
  map("n", "<leader>fk", function() picker.keymaps() end, { desc = "Keymaps" })
  map("n", "<leader>fn", function() picker.notifications() end, { desc = "Notification history" })
  map("n", "<leader>f.", function() picker.resume() end, { desc = "Resume last picker" })
  map("n", "<leader>fc", function()
    require("theme").load_all()
    picker.colorschemes()
  end, { desc = "Preview colorschemes" })
  map("n", "<leader><leader>", M.recent, { desc = "Recent files" })
end

-- Recent files open with the list focused: j/k + <CR>, or `/` (or `i`) to type.
function M.recent()
  Snacks.picker.recent({ focus = "list" })
end

return M
