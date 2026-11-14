local M = {}

function M.setup()
  vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

  -- Saves a session per working directory on exit (when at least one file is open).
  require("persistence").setup()

  -- Sidebar windows don't restore cleanly; close them before saving.
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("PersistenceCleanup", { clear = true }),
    pattern = "PersistenceSavePre",
    callback = function()
      pcall(function()
        require("nvim-tree.api").tree.close()
      end)
      pcall(function()
        require("trouble").close()
      end)
      -- Diffview tabs would come back as empty diffview:// buffers.
      if package.loaded["diffview.lib"] then
        local lib = require("diffview.lib")
        for _, view in ipairs(vim.list_slice(lib.views)) do
          pcall(function()
            view:close()
            lib.dispose_view(view)
          end)
        end
      end
    end,
  })

  local persistence = require("persistence")
  local map = vim.keymap.set
  map("n", "<leader>qs", persistence.load, { desc = "Restore session for this directory" })
  map("n", "<leader>ql", function()
    persistence.load({ last = true })
  end, { desc = "Restore last session" })
  map("n", "<leader>qS", persistence.select, { desc = "Pick a session" })
  map("n", "<leader>qd", persistence.stop, { desc = "Don't save this session" })
end

return M
