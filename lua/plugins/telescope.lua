local M = {}

function M.setup()
  require("telescope").setup({
    defaults = {
      initial_mode = "normal",
      prompt_prefix = " > ",
      selection_caret = " > ",
      sorting_strategy = "ascending",
      layout_config = { prompt_position = "top" },
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    pickers = {
      oldfiles = {
        include_current_session = false,
        prompt_title = "Recent files",
      },
      live_grep = {
        initial_mode = "insert",
      },
    },
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("RecentFiles", { clear = true }),
    callback = function(event)
      if vim.bo[event.buf].buftype ~= "" then
        return
      end

      local file = vim.api.nvim_buf_get_name(event.buf)
      if vim.fn.filereadable(file) ~= 1 then
        return
      end

      local key = function(path)
        return vim.fs.normalize(path):lower()
      end
      local recent = vim.tbl_filter(function(path)
        return key(path) ~= key(file)
      end, vim.v.oldfiles)
      table.insert(recent, 1, file)
      vim.v.oldfiles = recent
    end,
  })

  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search text" })
  vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find open buffers" })
  vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Recent files" })
end

return M
