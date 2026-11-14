local M = {}

function M.setup()
  require("blink.cmp").setup({
    keymap = {
      preset = "default",
      -- Keep the old behavior: <CR> accepts only an explicitly selected item.
      ["<CR>"] = { "accept", "fallback" },
    },
    completion = {
      list = { selection = { preselect = false, auto_insert = false } },
      menu = {
        border = "rounded",
        max_height = 10,
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind" } },
        },
      },
      documentation = { auto_show = true, auto_show_delay_ms = 300, window = { border = "rounded" } },
    },
    signature = { enabled = true, window = { border = "rounded" } },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    -- Command-line completion is handled by native wildtrigger() + noice.
    cmdline = { enabled = false },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  })
end

return M
