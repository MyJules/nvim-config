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
      indicator = { icon = "▎", style = "icon" },
      show_buffer_icons = true,
      show_close_icon = false,
      buffer_close_icon = "󰅖",
      modified_icon = "●",
      left_trunc_marker = "",
      right_trunc_marker = "",
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local parts = {}
        if diag.error then
          table.insert(parts, " " .. diag.error)
        end
        if diag.warning then
          table.insert(parts, " " .. diag.warning)
        end
        return table.concat(parts, " ")
      end,
      offsets = {
        {
          filetype = "NvimTree",
          text = "  Explorer",
          text_align = "left",
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

  vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next file tab" })
  vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous file tab" })
  vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Pick file tab" })
  vim.keymap.set("n", "<leader>bd", function()
    M.close()
  end, { desc = "Close file tab without closing splits" })
end

return M
