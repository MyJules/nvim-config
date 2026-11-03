local M = {}

function M.setup()
  require("nvim-tree").setup({
    hijack_netrw = false,
    view = { width = 30 },
    renderer = {
      group_empty = true,
      icons = {
        show = { file = false, folder = false, folder_arrow = true, git = false },
      },
    },
    filters = { dotfiles = false },
    update_focused_file = { enable = true },
  })

  local api = require("nvim-tree.api")
  vim.keymap.set("n", "<leader>e", api.tree.toggle, { desc = "Toggle file tree" })
  vim.keymap.set("n", "<leader>E", function()
    api.tree.find_file({ open = true, focus = true })
  end, { desc = "Reveal current file in tree" })
end

return M
