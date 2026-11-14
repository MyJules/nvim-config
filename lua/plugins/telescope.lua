local M = {}

function M.setup()
  local telescope = require("telescope")
  telescope.setup({
    defaults = {
      initial_mode = "normal",
      prompt_prefix = "   ",
      selection_caret = "  ",
      sorting_strategy = "ascending",
      layout_config = { prompt_position = "top" },
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    pickers = {
      oldfiles = {
        include_current_session = false,
        prompt_title = "Recent files",
      },
      live_grep = { initial_mode = "insert" },
      help_tags = { initial_mode = "insert" },
      lsp_document_symbols = { initial_mode = "insert" },
    },
    extensions = {
      fzf = {},
    },
  })
  -- Native fzf sorter; built by the PackChanged hook in plugins.lua.
  pcall(telescope.load_extension, "fzf")

  local builtin = require("telescope.builtin")
  local map = vim.keymap.set
  map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
  map("n", "<leader>fg", builtin.live_grep, { desc = "Search text" })
  map({ "n", "x" }, "<leader>fw", builtin.grep_string, { desc = "Search word/selection" })
  map("n", "<leader>fb", builtin.buffers, { desc = "Find open buffers" })
  map("n", "<leader>fh", builtin.help_tags, { desc = "Search help" })
  map("n", "<leader>fd", builtin.diagnostics, { desc = "Workspace diagnostics" })
  map("n", "<leader>fr", builtin.lsp_references, { desc = "LSP references" })
  map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
  map("n", "<leader>fk", builtin.keymaps, { desc = "Keymaps" })
  map("n", "<leader>f.", builtin.resume, { desc = "Resume last picker" })
  map("n", "<leader>fc", function()
    require("theme").load_all()
    builtin.colorscheme({ enable_preview = true, initial_mode = "insert" })
  end, { desc = "Preview colorschemes" })
  map("n", "<leader><leader>", builtin.oldfiles, { desc = "Recent files" })
end

return M
