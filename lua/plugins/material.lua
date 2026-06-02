local M = {}

function M.setup()
  vim.g.material_style = "darker"
  vim.cmd.colorscheme("material")
end

return M
