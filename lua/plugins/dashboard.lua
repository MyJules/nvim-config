local M = {}

local WIDTH = 50
local PANE_GAP = 8

-- Measure once, when startup finishes, so redraws don't inflate the number.
local startup_ms
vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    startup_ms = (vim.uv.hrtime() - (vim.g.start_time or vim.uv.hrtime())) / 1e6
  end,
})

local logo = {
  [[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
  [[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
  [[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
  [[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
  [[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
  [[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
}

local tips = {
  { "<Space><Space>", "recent files" },
  { "<Space>fg", "search text in the project" },
  { "<Space>f.", "reopen the last picker" },
  { "<Space>xx", "list all diagnostics" },
  { "<Space>qs", "restore this folder's session" },
  { "<Space>gp", "preview the git hunk under the cursor" },
  { "<Space>gg", "lazygit: branches, rebase, stash, push" },
  { "<Space>ls", "switch between source and header" },
  { "<Space>fc", "preview colorschemes" },
  { "sa iw )", "surround a word with parentheses" },
  { "vif", "select the body of a function" },
  { "daa", "delete a function argument" },
  { "gra / grn", "code action / rename symbol" },
}
local tip = tips[(os.time() % #tips) + 1]

local function wide()
  return vim.o.columns >= WIDTH * 2 + PANE_GAP + 4
end

-- Dashboard actions may fire before deferred plugins finish loading.
local function run(cmd)
  return function()
    require("plugins").ensure_loaded()
    if type(cmd) == "function" then
      cmd()
    else
      vim.cmd(cmd)
    end
  end
end

local function header()
  local items = {}
  for i, line in ipairs(logo) do
    items[#items + 1] = { text = { line, hl = "DashboardLogo" .. i }, align = "center" }
  end
  return items
end

local function greeting()
  local hour = tonumber(os.date("%H"))
  local part = hour < 5 and "Up late" or hour < 12 and "Good morning" or hour < 18 and "Good afternoon" or "Good evening"
  return {
    align = "center",
    padding = 1,
    text = {
      { part, hl = "SnacksDashboardDesc" },
      { "  ·  ", hl = "SnacksDashboardDir" },
      { os.date("%A, %d %B"), hl = "SnacksDashboardDir" },
    },
  }
end

local function footer()
  local ms = startup_ms or (vim.uv.hrtime() - (vim.g.start_time or vim.uv.hrtime())) / 1e6
  -- Not vim.pack.get(): it runs git for every plugin, ~200 ms per redraw.
  local count = #require("plugins").list
  local v = vim.version()
  local sep = { "   ", hl = "SnacksDashboardDir" }
  return {
    align = "center",
    padding = 1,
    text = {
      { " ", hl = "SnacksDashboardSpecial" },
      { ("v%d.%d.%d"):format(v.major, v.minor, v.patch), hl = "SnacksDashboardFooter" },
      sep,
      { "󰏗 ", hl = "SnacksDashboardSpecial" },
      { count .. " plugins", hl = "SnacksDashboardFooter" },
      sep,
      { "󱐋 ", hl = "SnacksDashboardSpecial" },
      { ("%.0f ms"):format(ms), hl = "SnacksDashboardFooter" },
    },
  }
end

local function tip_line()
  return {
    align = "center",
    text = {
      { "󰌵 ", hl = "SnacksDashboardKey" },
      { tip[1], hl = "SnacksDashboardSpecial" },
      { "  " .. tip[2], hl = "SnacksDashboardDir" },
    },
  }
end

-- "name  dimmed/dir" with forward slashes; paths inside the cwd are shown relative.
local function format_file(item, ctx)
  local path = vim.fs.normalize(item.file)
  local cwd = vim.fs.normalize(vim.fn.getcwd())
  if path:lower():sub(1, #cwd + 1) == (cwd .. "/"):lower() then
    path = path:sub(#cwd + 2)
  else
    path = vim.fs.normalize(vim.fn.fnamemodify(path, ":~"))
  end
  local dir, name = path:match("^(.*)/([^/]+)$")
  if not dir then
    return { { path, hl = "file" } }
  end
  local room = (ctx.width or WIDTH) - vim.api.nvim_strwidth(name) - 2
  if vim.api.nvim_strwidth(dir) > room then
    dir = vim.fn.pathshorten(dir)
    if vim.api.nvim_strwidth(dir) > room then
      dir = "…" .. dir:sub(-math.max(room - 1, 1))
    end
  end
  return { { name, hl = "file" }, { "  " .. dir, hl = "dir" } }
end

local temp_dir = vim.env.TEMP and (vim.fs.normalize(vim.env.TEMP):lower() .. "/")

-- Skip directories (e.g. from `nvim .`) and scratch files under %TEMP%.
local function is_file(file)
  if temp_dir and vim.fs.normalize(file):lower():sub(1, #temp_dir) == temp_dir then
    return false
  end
  return vim.fn.isdirectory(file) == 0
end

local function in_cwd(file)
  local root = vim.fs.normalize(vim.fn.getcwd()):lower() .. "/"
  return vim.fs.normalize(file):lower():sub(1, #root) == root
end

function M.setup()
  local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

  require("snacks").setup({
    -- Files over 1.5 MB get filetype "bigfile": no treesitter, LSP, folds, etc.
    bigfile = { enabled = true },
    lazygit = { enabled = true },
    dashboard = {
      enabled = true,
      width = WIDTH,
      pane_gap = PANE_GAP,
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find file", action = run("Telescope find_files") },
          { icon = " ", key = "g", desc = "Search text", action = run("Telescope live_grep") },
          { icon = " ", key = "r", desc = "Recent files", action = run("Telescope oldfiles") },
          {
            icon = " ",
            key = "s",
            desc = "Restore session",
            action = run(function()
              require("persistence").load()
            end),
          },
          { icon = " ", key = "e", desc = "File tree", action = run("NvimTreeOpen") },
          { icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = run(function()
              require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
            end),
          },
          { icon = "󰚰 ", key = "u", desc = "Update plugins", action = run("PackUpdate") },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      formats = {
        key = function(item)
          return { { " " .. item.key .. " ", hl = "DashboardKeyBadge" } }
        end,
        file = format_file,
      },
      sections = {
        -- Left pane
        header,
        greeting,
        { section = "keys", padding = 1, indent = 2 },
        -- Narrow windows: one short list instead of the whole right pane stacked below.
        {
          icon = " ",
          title = "Recent",
          section = "recent_files",
          filter = is_file,
          limit = 5,
          indent = 2,
          padding = 1,
          enabled = function()
            return not wide()
          end,
        },
        footer,
        tip_line,

        -- Right pane (only when there's room for it)
        { pane = 2, text = "", padding = 7, enabled = wide },
        {
          pane = 2,
          icon = " ",
          title = "Recent in " .. project,
          section = "recent_files",
          cwd = true,
          filter = is_file,
          limit = 6,
          indent = 2,
          padding = 1,
          enabled = wide,
        },
        {
          pane = 2,
          icon = " ",
          title = "Elsewhere",
          section = "recent_files",
          limit = 4,
          indent = 2,
          padding = 1,
          filter = function(file)
            return is_file(file) and not in_cwd(file)
          end,
          enabled = wide,
        },
        {
          pane = 2,
          icon = " ",
          title = "Projects",
          section = "projects",
          limit = 4,
          indent = 2,
          padding = 1,
          enabled = wide,
        },
      },
    },
  })

  vim.keymap.set("n", "<leader>sd", function()
    Snacks.dashboard()
  end, { desc = "Open dashboard" })
end

return M
