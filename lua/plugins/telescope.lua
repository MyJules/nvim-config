local M = {}

function M.setup()
  require("telescope").setup({
    defaults = {
      initial_mode = "normal",
    },
    pickers = {
      live_grep = {
        initial_mode = "insert",
      },
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({}),
      },
    },
  })

  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
  vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})

  require("telescope").load_extension("ui-select")
end

return M
