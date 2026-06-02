local M = {}

function M.setup()
  require("neo-tree").setup({
    default_component_configs = {
      indent = { indent_size = 2 },
    },
    window = {
      width = 25,
    },
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  })

  vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left<CR>", {})
end

return M
