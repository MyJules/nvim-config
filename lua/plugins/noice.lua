local M = {}

function M.setup()
  require("noice").setup({
    cmdline = {
      format = {
        cmdline = { icon = ":", title = " Command " },
        search_down = { icon = "/" },
        search_up = { icon = "?" },
        filter = { icon = "$" },
        lua = { icon = "lua" },
        help = { icon = "?" },
        input = { icon = ">" },
      },
    },
    popupmenu = { backend = "nui", kind_icons = false },
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
