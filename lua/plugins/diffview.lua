-- Side-by-side review of every changed file (great for reviewing AI-generated edits).
local M = {}

function M.setup()
  local actions = require("diffview.actions")

  require("diffview").setup({
    enhanced_diff_hl = true, -- highlight changed words inside changed lines
    show_help_hints = true,
    view = {
      default = { layout = "diff2_horizontal", winbar_info = true },
      file_history = { layout = "diff2_horizontal", winbar_info = true },
      merge_tool = { layout = "diff3_horizontal", disable_diagnostics = true },
    },
    file_panel = {
      listing_style = "tree",
      win_config = { position = "left", width = 34 },
    },
    keymaps = {
      view = {
        { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
        { "n", "]f", actions.select_next_entry, { desc = "Next file" } },
        { "n", "[f", actions.select_prev_entry, { desc = "Previous file" } },
      },
      file_panel = {
        { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
      },
      file_history_panel = {
        { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
      },
    },
  })

  local map = vim.keymap.set
  map("n", "<leader>gv", "<Cmd>DiffviewOpen<CR>", { desc = "Review all changes (diffview)" })
  map("n", "<leader>gV", "<Cmd>DiffviewOpen HEAD~1<CR>", { desc = "Review last commit" })
  map("n", "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", { desc = "File history" })
  map("n", "<leader>gH", "<Cmd>DiffviewFileHistory<CR>", { desc = "Repo history" })
  map("x", "<leader>gh", ":DiffviewFileHistory<CR>", { desc = "History of selection" })
end

return M
