local M = {}

function M.setup()
  require("catppuccin").setup({
    flavour = "mocha",
    term_colors = true,
    integrations = {
      nvimtree = true,
      telescope = { enabled = true },
    },
    custom_highlights = function(colors)
      return {
        FloatBorder = { fg = colors.surface2, bg = colors.mantle },
        NormalFloat = { fg = colors.text, bg = colors.mantle },
      }
    end,
  })
  vim.cmd.colorscheme("catppuccin")
end

return M
