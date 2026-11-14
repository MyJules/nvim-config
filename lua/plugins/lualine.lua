local M = {}

function M.setup()
  require("lualine").setup({
    options = {
      theme = "tokyonight",
      globalstatus = true,
      icons_enabled = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { statusline = { "snacks_dashboard" } },
    },
    sections = {
      lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
      lualine_b = { "branch", "diff" },
      lualine_c = {
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" } },
        "diagnostics",
      },
      lualine_x = {
        {
          function()
            local names = vim.tbl_map(function(c)
              return c.name
            end, vim.lsp.get_clients({ bufnr = 0 }))
            return #names > 0 and (" " .. table.concat(names, ", ")) or ""
          end,
        },
        "encoding",
        { "fileformat", symbols = { unix = "LF", dos = "CRLF", mac = "CR" } },
      },
      lualine_y = { "progress" },
      lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
    },
    extensions = { "nvim-tree", "trouble", "quickfix" },
  })
end

return M
