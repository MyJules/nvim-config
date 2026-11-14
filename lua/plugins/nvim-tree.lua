local M = {}

function M.setup()
  require("nvim-tree").setup({
    -- netrw is disabled in options.lua; this also lets `nvim <dir>` open the tree.
    disable_netrw = true,
    view = {
      width = 30,
      signcolumn = "no",
    },
    renderer = {
      group_empty = true,
      root_folder_label = ":t",
      highlight_git = "name",
      highlight_opened_files = "name",
      highlight_modified = "name",
      indent_markers = { enable = true },
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
          modified = true,
          diagnostics = true,
          bookmarks = true,
        },
        glyphs = {
          git = {
            unstaged = "",
            staged = "",
            unmerged = "",
            renamed = "➜",
            untracked = "",
            deleted = "",
            ignored = "◌",
          },
        },
      },
    },
    diagnostics = { enable = true, show_on_dirs = true },
    modified = { enable = true },
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
