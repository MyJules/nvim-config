local M = {}

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
  vim.cmd.colorscheme("tokyonight")
end

return M
