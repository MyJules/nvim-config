local M = {}

local function github(repo)
  return "https://github.com/" .. repo
end

local plugins = {
  { src = github("marko-cerovac/material.nvim") },
  { src = github("nvim-tree/nvim-tree.lua") },
  { src = github("nvim-lua/plenary.nvim") },
  { src = github("nvim-telescope/telescope.nvim"), version = "v0.2.2" },
  { src = github("nvim-lualine/lualine.nvim") },
  { src = github("akinsho/bufferline.nvim"), version = "v4.9.1" },
  { src = github("nvim-mini/mini.bufremove") },
  { src = github("startup-nvim/startup.nvim") },
  { src = github("MunifTanjim/nui.nvim") },
  { src = github("folke/noice.nvim") },
}

function M.setup()
  vim.pack.add(plugins, {
    confirm = false,
    load = true,
  })

  require("theme").setup()
  require("plugins.lualine").setup()
  require("plugins.bufferline").setup()
  require("plugins.nvim-tree").setup()
  require("plugins.telescope").setup()
  require("plugins.startup").setup()
  require("plugins.noice").setup()
end

return M
