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
      hl.StartupLogo = { fg = c.purple, bold = true }
      hl.StartupMuted = { fg = c.comment }
      hl.StartupActions = { fg = c.cyan }
      hl.StartupHint = { fg = c.orange }
    end,
  })
  vim.cmd.colorscheme("tokyonight")
end

return M
