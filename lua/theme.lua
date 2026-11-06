local M = {}

function M.setup()
  vim.g.material_style = "darker"
  require("material").setup({
    plugins = { "mini", "noice", "nvim-tree", "telescope" },
    contrast = {
      floating_windows = true,
    },
    custom_highlights = function(colors)
      return {
        StartupLogo = { fg = colors.main.purple, bold = true },
        StartupMuted = { fg = colors.editor.fg_dark },
        StartupActions = { fg = colors.main.cyan },
        StartupHint = { fg = colors.main.orange },
      }
    end,
  })
  vim.cmd.colorscheme("material")
end

return M
