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
    end,
  })
  vim.cmd.colorscheme("tokyonight")
end

return M
