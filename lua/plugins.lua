local M = {}

local function github(repo)
  return "https://github.com/" .. repo
end

local plugins = {
  { src = github("marko-cerovac/material.nvim") },
  { src = github("nvim-tree/nvim-tree.lua") },
  { src = github("nvim-lua/plenary.nvim") },
  { src = github("nvim-telescope/telescope.nvim"), version = "v0.2.2" },
  { src = github("nvim-telescope/telescope-fzf-native.nvim") },
  { src = github("nvim-lualine/lualine.nvim") },
  { src = github("akinsho/bufferline.nvim"), version = "v4.9.1" },
  { src = github("nvim-mini/mini.bufremove") },
  { src = github("nvim-mini/mini.clue") },
  { src = github("startup-nvim/startup.nvim") },
  { src = github("MunifTanjim/nui.nvim") },
  { src = github("folke/noice.nvim") },
  { src = github("nvim-treesitter/nvim-treesitter"), version = "main" },
  { src = github("lewis6991/gitsigns.nvim") },
  { src = github("saghen/blink.cmp"), version = vim.version.range("1.*") },
}

-- Post-install/update build steps. Must be registered before vim.pack.add().
local builds = {
  ["telescope-fzf-native.nvim"] = function(path)
    local function run(cmd)
      local result = vim.system(cmd, { cwd = path }):wait()
      if result.code ~= 0 then
        error(result.stderr ~= "" and result.stderr or result.stdout)
      end
    end
    run({ "cmake", "-S.", "-Bbuild", "-G", "MinGW Makefiles", "-DCMAKE_BUILD_TYPE=Release" })
    run({ "cmake", "--build", "build", "--config", "Release" })
  end,
  ["nvim-treesitter"] = function()
    vim.schedule(function()
      pcall(vim.cmd, "TSUpdate")
    end)
  end,
}

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("PackBuild", { clear = true }),
  callback = function(event)
    local data = event.data
    if data.kind == "delete" then
      return
    end
    local build = builds[data.spec.name]
    if build then
      local ok, err = pcall(build, data.path)
      if not ok then
        vim.notify(("Build failed for %s:\n%s"):format(data.spec.name, err), vim.log.levels.ERROR)
      end
    end
  end,
})

function M.setup()
  vim.pack.add(plugins, {
    confirm = false,
    load = true,
  })

  vim.api.nvim_create_user_command("PackUpdate", function(cmd)
    vim.pack.update(#cmd.fargs > 0 and cmd.fargs or nil)
  end, { nargs = "*", desc = "Update plugins (all, or the named ones)" })

  require("theme").setup()
  require("plugins.treesitter").setup()
  require("plugins.lualine").setup()
  require("plugins.bufferline").setup()
  require("plugins.nvim-tree").setup()
  require("plugins.telescope").setup()
  require("plugins.gitsigns").setup()
  require("plugins.blink").setup()
  require("plugins.clue").setup()
  require("plugins.startup").setup()
  require("plugins.noice").setup()
end

return M
