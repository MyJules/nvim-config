local M = {}

local function github(repo)
  return "https://github.com/" .. repo
end

local plugins = {
  { src = github("folke/tokyonight.nvim") },
  { src = github("catppuccin/nvim"), name = "catppuccin" },
  { src = github("rebelot/kanagawa.nvim") },
  { src = github("rose-pine/neovim"), name = "rose-pine" },
  { src = github("nvim-tree/nvim-tree.lua") },
  { src = github("nvim-lua/plenary.nvim") },
  { src = github("nvim-telescope/telescope.nvim"), version = "v0.2.2" },
  { src = github("nvim-telescope/telescope-fzf-native.nvim") },
  { src = github("nvim-lualine/lualine.nvim") },
  { src = github("akinsho/bufferline.nvim"), version = "v4.9.1" },
  { src = github("nvim-mini/mini.nvim") },
  { src = github("folke/snacks.nvim") },
  { src = github("MunifTanjim/nui.nvim") },
  { src = github("folke/noice.nvim") },
  { src = github("nvim-treesitter/nvim-treesitter"), version = "main" },
  { src = github("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },
  { src = github("lewis6991/gitsigns.nvim") },
  { src = github("sindrets/diffview.nvim") },
  { src = github("saghen/blink.cmp"), version = vim.version.range("1.*") },
  { src = github("folke/persistence.nvim") },
  { src = github("folke/trouble.nvim") },
}
M.list = plugins

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

-- Plugins needed to draw the first screen. Everything else loads right after it.
local eager = { "tokyonight.nvim", "mini.nvim", "snacks.nvim" }

local function packadd(names)
  for _, name in ipairs(names) do
    vim.cmd.packadd(name)
  end
end

local function opened_directory()
  local arg = vim.fn.argv(0)
  return vim.fn.argc() > 0 and arg ~= "" and vim.fn.isdirectory(arg) == 1
end

-- Loaded after the first screen, one step per event-loop tick so the UI stays
-- responsive (all at once is ~95 ms of frozen input). Order matters: UI bars first,
-- blink before lsp (capabilities), mini.clue last (it scans existing keymaps).
local steps = {
  { { "lualine.nvim" }, "plugins.lualine" },
  { { "bufferline.nvim" }, "plugins.bufferline" },
  { { "nvim-treesitter", "nvim-treesitter-textobjects" }, "plugins.treesitter", "setup_deferred" },
  { { "plenary.nvim", "telescope.nvim", "telescope-fzf-native.nvim" }, "plugins.telescope" },
  { { "nvim-tree.lua" }, "plugins.nvim-tree" },
  { { "gitsigns.nvim" }, "plugins.gitsigns" },
  { { "diffview.nvim" }, "plugins.diffview" },
  { { "blink.cmp" }, "plugins.blink" },
  { {}, "lsp" },
  { {}, "plugins.mini" },
  { { "persistence.nvim" }, "plugins.sessions" },
  { { "trouble.nvim" }, "plugins.trouble" },
  { { "nui.nvim", "noice.nvim" }, "plugins.noice" },
  { {}, "plugins.clue" },
}
local next_step = 1

local function run_step(step)
  local packs, module, fn = step[1], step[2], step[3] or "setup"
  if module == "plugins.nvim-tree" and package.loaded["nvim-tree"] then
    return -- already loaded for `nvim <dir>`
  end
  packadd(packs)
  local mod = require(module)
  if type(mod) == "table" and mod[fn] then
    mod[fn]()
  end
end

local function done()
  return next_step > #steps
end

local function finish_event()
  vim.api.nvim_exec_autocmds("User", { pattern = "DeferredLoaded", modeline = false })
end

-- Equivalent of lazy.nvim's "VeryLazy": runs once the UI is up.
function M.load_deferred()
  if done() then
    return
  end
  run_step(steps[next_step])
  next_step = next_step + 1
  if done() then
    finish_event()
  else
    vim.defer_fn(M.load_deferred, 0)
  end
end

-- Finish any remaining steps right now (e.g. a dashboard key pressed very early).
function M.ensure_loaded()
  if done() then
    return
  end
  while not done() do
    run_step(steps[next_step])
    next_step = next_step + 1
  end
  finish_event()
end

function M.setup()
  -- Register (and install if missing) everything, but don't load anything yet.
  vim.pack.add(plugins, { confirm = false, load = function() end })

  vim.api.nvim_create_user_command("PackUpdate", function(cmd)
    vim.pack.update(#cmd.fargs > 0 and cmd.fargs or nil)
  end, { nargs = "*", desc = "Update plugins (all, or the named ones)" })

  packadd(eager)
  require("theme").setup()
  require("plugins.mini").icons()
  require("plugins.treesitter").setup()
  require("plugins.dashboard").setup()

  -- Blank status/tab lines until lualine and bufferline load (avoids a flash of the
  -- default ones and keeps the layout from shifting).
  vim.o.statusline = " "
  vim.o.tabline = " "

  -- `nvim <dir>` needs the tree before the first draw.
  if opened_directory() then
    vim.cmd.packadd("nvim-tree.lua")
    require("plugins.nvim-tree").setup()
  end

  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("DeferredPlugins", { clear = true }),
    once = true,
    callback = function()
      vim.schedule(M.load_deferred)
    end,
  })
end

return M
