local M = {}

local function github(repo)
  return "https://github.com/" .. repo
end

local plugins = {
  { src = github("marko-cerovac/material.nvim") },
  { src = github("j-hui/fidget.nvim") },
  { src = github("lewis6991/gitsigns.nvim") },
  { src = github("mason-org/mason.nvim") },
  { src = github("neovim/nvim-lspconfig") },
  { src = github("hrsh7th/cmp-nvim-lsp") },
  { src = github("hrsh7th/cmp-buffer") },
  { src = github("L3MON4D3/LuaSnip") },
  { src = github("saadparwaiz1/cmp_luasnip") },
  { src = github("rafamadriz/friendly-snippets") },
  { src = github("hrsh7th/nvim-cmp") },
  { src = github("nvim-treesitter/nvim-treesitter"), version = "v0.26.9" },
  { src = github("nvim-telescope/telescope-ui-select.nvim") },
  { src = github("nvim-lua/plenary.nvim") },
  { src = github("nvim-telescope/telescope.nvim"), version = "0.1.5" },
  { src = github("nvim-neo-tree/neo-tree.nvim"), version = "v3.x" },
  { src = github("nvim-tree/nvim-web-devicons") },
  { src = github("MunifTanjim/nui.nvim") },
  { src = github("nvim-lualine/lualine.nvim") },
}

local config_modules = {
  "plugins.material",
  "plugins.fidget",
  "plugins.gitsigns",
  "plugins.lsp-config",
  "plugins.completions",
  "plugins.treesitter",
  "plugins.telescope",
  "plugins.neo-tree",
  "plugins.lualine",
}

local function setup_pack_changed_hook()
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      if ev.data.spec.name == "nvim-treesitter" and (ev.data.kind == "install" or ev.data.kind == "update") then
        if not ev.data.active then
          vim.cmd.packadd("nvim-treesitter")
        end
        vim.cmd("TSUpdateSync")
      end
    end,
  })
end

function M.setup()
  setup_pack_changed_hook()

  vim.pack.add(plugins, {
    confirm = false,
    load = true,
  })

  for _, module_name in ipairs(config_modules) do
    require(module_name).setup()
  end
end

return M
