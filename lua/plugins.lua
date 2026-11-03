local M = {}

local function github(repo)
  return "https://github.com/" .. repo
end

local plugins = {
  { src = github("catppuccin/nvim"), name = "catppuccin" },
  { src = github("nvim-tree/nvim-tree.lua") },
  { src = github("nvim-lua/plenary.nvim") },
  { src = github("nvim-telescope/telescope.nvim"), version = "v0.2.2" },
}

function M.setup()
  vim.pack.add(plugins, {
    confirm = false,
    load = true,
  })

  require("theme").setup()
  require("plugins.nvim-tree").setup()
  require("plugins.telescope").setup()
end

return M
