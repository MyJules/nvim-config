local M = {}

function M.setup()
  require("noice").setup({
    cmdline = { view = "cmdline_popup" },
    popupmenu = { backend = "nui" },
    messages = { enabled = false },
    notify = { enabled = false },
    lsp = {
      progress = { enabled = false },
      hover = { enabled = false },
      signature = { enabled = false },
      message = { enabled = false },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
    },
    views = {
      cmdline_popup = { border = { style = "rounded" } },
      cmdline_popupmenu = {
        border = { style = "rounded" },
        size = { max_height = 10 },
      },
    },
  })

  vim.opt.wildmode = { "noselect:lastused", "full" }
  vim.opt.wildoptions:append("pum")
  vim.api.nvim_create_autocmd("CmdlineChanged", {
    group = vim.api.nvim_create_augroup("CommandSuggestions", { clear = true }),
    pattern = ":",
    callback = function()
      vim.fn.wildtrigger()
    end,
  })
end

return M
