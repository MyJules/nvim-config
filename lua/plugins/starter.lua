local M = {}

function M.setup()
  local starter = require("mini.starter")
  local telescope = require("telescope.builtin")

  starter.setup({
    evaluate_single = true,
    header = table.concat({
      "N E O V I M",
      "----------",
      "A quiet place to build.",
    }, "\n"),
    items = {
      { name = "Find files", action = telescope.find_files, section = "Start" },
      { name = "Recent files", action = telescope.oldfiles, section = "Start" },
      { name = "New file", action = "enew", section = "Start" },
      { name = "Explore files", action = require("nvim-tree.api").tree.open, section = "Start" },
      { name = "Quit", action = "qa", section = "Start" },
    },
    footer = function()
      return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
        .. "\n\nType f / r / n / e / q, or use arrows and Enter"
    end,
    content_hooks = {
      starter.gen_hook.adding_bullet("  > "),
      starter.gen_hook.aligning("center", "center"),
    },
  })

  vim.keymap.set("n", "<leader>sd", starter.open, { desc = "Open startup dashboard" })
end

return M
