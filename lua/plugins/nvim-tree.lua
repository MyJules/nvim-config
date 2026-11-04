local M = {}

function M.setup()
  require("nvim-tree").setup({
    hijack_netrw = false,
    view = {
      width = 34,
      signcolumn = "no",
    },
    renderer = {
      group_empty = true,
      root_folder_label = ":t",
      add_trailing = true,
      highlight_git = "name",
      highlight_opened_files = "name",
      highlight_modified = "name",
      indent_markers = {
        enable = true,
        icons = {
          corner = "`",
          edge = "|",
          item = "|",
          bottom = "-",
          none = " ",
        },
      },
      icons = {
        web_devicons = {
          file = { enable = false },
          folder = { enable = false },
        },
        symlink_arrow = " -> ",
        show = {
          file = false,
          folder = false,
          folder_arrow = false,
          git = false,
          modified = false,
          hidden = false,
          diagnostics = false,
          bookmarks = false,
        },
      },
    },
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
