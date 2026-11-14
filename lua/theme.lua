-- Colorschemes: tokyonight (always loaded) plus a few extras that are only added
-- to the runtimepath when used. The last theme you pick is remembered.
local M = {}

-- Extra theme plugins: package name -> colorscheme name prefix.
M.extras = {
  { pack = "catppuccin", prefix = "catppuccin" },
  { pack = "kanagawa.nvim", prefix = "kanagawa" },
  { pack = "rose-pine", prefix = "rose-pine" },
}

local default = "tokyonight"
local state_file = vim.fn.stdpath("state") .. "/colorscheme"

local function read_saved()
  local f = io.open(state_file, "r")
  if not f then
    return nil
  end
  local name = vim.trim(f:read("*a") or "")
  f:close()
  return name ~= "" and name or nil
end

local function save(name)
  local f = io.open(state_file, "w")
  if f then
    f:write(name)
    f:close()
  end
end

-- Make the extra themes visible to :colorscheme and the picker.
function M.load_all()
  for _, t in ipairs(M.extras) do
    pcall(vim.cmd.packadd, t.pack)
  end
end

local function load_for(name)
  for _, t in ipairs(M.extras) do
    if vim.startswith(name, t.prefix) then
      pcall(vim.cmd.packadd, t.pack)
    end
  end
end

local function get(name, attr)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  return hl[attr]
end

-- Our custom groups are tuned for tokyonight in on_highlights below. For other
-- themes, derive them from the theme's own colors so nothing is left unstyled.
local function fallback_highlights()
  if vim.startswith(vim.g.colors_name or "", "tokyonight") then
    return
  end
  local set = vim.api.nvim_set_hl
  local logo = { "Function", "Function", "Statement", "Statement", "Type", "Type" }
  for i, group in ipairs(logo) do
    set(0, "DashboardLogo" .. i, { fg = get(group, "fg"), bold = true })
  end
  set(0, "DashboardKeyBadge", { fg = get("Constant", "fg"), bg = get("CursorLine", "bg"), bold = true })

  -- Command line popup (noice): same layout as the tokyonight tuning, so the box,
  -- its border and the completion list share the theme's float background.
  local float_bg = get("NormalFloat", "bg") or get("Normal", "bg")
  local accent = get("Function", "fg")
  set(0, "NoiceCmdlinePopup", { fg = get("NormalFloat", "fg") or get("Normal", "fg"), bg = float_bg })
  set(0, "NoiceCmdlinePopupBorder", { fg = accent, bg = float_bg })
  set(0, "NoiceCmdlinePopupTitle", { fg = float_bg, bg = accent, bold = true })
  set(0, "NoiceCmdlineIcon", { fg = get("Constant", "fg") })
  local kinds = { Search = "DiagnosticWarn", Lua = "Statement", Filter = "String" }
  for kind, source in pairs(kinds) do
    local fg = get(source, "fg")
    set(0, "NoiceCmdlinePopupBorder" .. kind, { fg = fg, bg = float_bg })
    set(0, "NoiceCmdlineIcon" .. kind, { fg = fg })
  end
end

function M.setup()
  require("tokyonight").setup({
    -- "moon" (soft, colorful), "storm" (bluer), "night" (darkest), "day" (light)
    style = "moon",
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      sidebars = "dark",
      floats = "dark",
    },
    on_highlights = function(hl, c)
      local util = require("tokyonight.util")
      -- Dashboard: logo fades from blue to magenta, top to bottom.
      for i = 1, 6 do
        hl["DashboardLogo" .. i] = { fg = util.blend(c.magenta, (i - 1) / 5, c.blue), bold = true }
      end
      hl.DashboardKeyBadge = { fg = c.orange, bg = c.bg_highlight, bold = true }
      hl.SnacksDashboardDesc = { fg = c.fg }
      hl.SnacksDashboardIcon = { fg = c.blue }
      hl.SnacksDashboardKey = { fg = c.orange }
      hl.SnacksDashboardTitle = { fg = c.magenta, bold = true }
      hl.SnacksDashboardFile = { fg = c.fg }
      hl.SnacksDashboardDir = { fg = c.comment }
      hl.SnacksDashboardFooter = { fg = c.fg_dark }
      hl.SnacksDashboardSpecial = { fg = c.cyan }
      hl.MiniIndentscopeSymbol = { fg = c.blue5 }
      -- Diffs: tinted line backgrounds, stronger tint for the exact changed words.
      hl.DiffAdd = { bg = util.blend(c.green, 0.18, c.bg) }
      hl.DiffDelete = { bg = util.blend(c.red, 0.18, c.bg) }
      hl.DiffChange = { bg = util.blend(c.blue, 0.12, c.bg) }
      hl.DiffText = { bg = util.blend(c.blue, 0.35, c.bg), bold = true }
      hl.DiffTextAdd = { bg = util.blend(c.green, 0.4, c.bg), bold = true }
      hl.DiffviewDiffAddAsDelete = { bg = util.blend(c.red, 0.18, c.bg) }
      hl.DiffviewDiffDelete = { fg = c.dark3 }
      -- Command line popup (noice).
      hl.NoiceCmdlinePopup = { fg = c.fg, bg = c.bg_dark }
      hl.NoiceCmdlinePopupBorder = { fg = c.blue, bg = c.bg_dark }
      hl.NoiceCmdlinePopupTitle = { fg = c.bg_dark, bg = c.blue, bold = true }
      hl.NoiceCmdlineIcon = { fg = c.orange }
      hl.NoiceCmdlinePopupBorderSearch = { fg = c.yellow, bg = c.bg_dark }
      hl.NoiceCmdlineIconSearch = { fg = c.yellow }
      hl.NoiceCmdlinePopupBorderLua = { fg = c.magenta, bg = c.bg_dark }
      hl.NoiceCmdlineIconLua = { fg = c.magenta }
      hl.NoiceCmdlinePopupBorderFilter = { fg = c.green, bg = c.bg_dark }
      hl.NoiceCmdlineIconFilter = { fg = c.green }
    end,
  })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("ThemePersist", { clear = true }),
    callback = function(event)
      fallback_highlights()
      -- Fires during picker previews too; cancelling re-applies the old theme,
      -- so the file always ends up holding the theme actually in use.
      save(event.match)
    end,
  })

  local saved = read_saved() or default
  load_for(saved)
  if not pcall(vim.cmd.colorscheme, saved) then
    vim.cmd.colorscheme(default)
  end
end

return M
