local M = {}

function M.close(buf)
  require("mini.bufremove").delete(buf, false)
end

function M.setup()
  require("bufferline").setup({
    options = {
      mode = "buffers",
      close_command = M.close,
      right_mouse_command = M.close,
      always_show_bufferline = true,
      separator_style = "thin",
      indicator = { style = "underline" },
      show_buffer_icons = false,
      show_close_icon = false,
      buffer_close_icon = "x",
      modified_icon = "+",
      left_trunc_marker = "<",
      right_trunc_marker = ">",
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count)
        return " " .. count
      end,
      offsets = {
        {
          filetype = "NvimTree",
          text = "Files",
          text_align = "center",
          highlight = "Directory",
          separator = true,
        },
      },
    },
    highlights = {
      buffer_selected = { bold = true, italic = false },
      diagnostic_selected = { bold = true, italic = false },
    },
  })

  vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Pick file tab" })
end

return M
