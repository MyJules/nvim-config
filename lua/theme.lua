local M = {}

function M.setup()
  vim.g.material_style = "darker"
  require("material").setup({
    plugins = { "mini", "nvim-tree", "telescope" },
    contrast = {
      floating_windows = true,
    },
  })
  vim.cmd.colorscheme("material")
end

return M
