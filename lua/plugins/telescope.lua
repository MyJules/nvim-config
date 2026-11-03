local M = {}

function M.setup()
  require("telescope").setup({
    defaults = {
      initial_mode = "normal",
      prompt_prefix = " > ",
      selection_caret = " > ",
      sorting_strategy = "ascending",
      layout_config = { prompt_position = "top" },
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    pickers = {
      live_grep = {
        initial_mode = "insert",
      },
    },
  })

  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search text" })
  vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find open buffers" })
  vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Recent files" })
end

return M
