-- Small modules from mini.nvim: icons, editing helpers, indent scope.
local M = {}

function M.icons()
  require("mini.icons").setup()
  -- bufferline, nvim-tree, lualine and telescope expect nvim-web-devicons.
  MiniIcons.mock_nvim_web_devicons()
end

function M.setup()
  -- Auto-close brackets and quotes.
  require("mini.pairs").setup({
    modes = { insert = true, command = false, terminal = false },
  })

  -- sa{motion}{char} add, sd{char} delete, sr{old}{new} replace, sf/sF find, sh highlight.
  require("mini.surround").setup()

  -- Extra text objects: af/if function, ac/ic class, ao/io block/conditional/loop,
  -- aa/ia argument, au/iu function call, plus "next"/"last" variants (an(, il" ...).
  local ai = require("mini.ai")
  local ts = ai.gen_spec.treesitter
  ai.setup({
    n_lines = 500,
    custom_textobjects = {
      f = ts({ a = "@function.outer", i = "@function.inner" }),
      c = ts({ a = "@class.outer", i = "@class.inner" }),
      o = ts({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
      u = ai.gen_spec.function_call(),
    },
  })

  -- Highlight the indent scope around the cursor; also gives ii/ai and [i/]i.
  require("mini.indentscope").setup({
    symbol = "│",
    draw = { delay = 50, animation = require("mini.indentscope").gen_animation.none() },
    options = { try_as_border = true },
  })
  local disabled_ft = { "help", "NvimTree", "snacks_dashboard", "trouble", "noice", "TelescopePrompt", "TelescopeResults" }
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("IndentScopeDisable", { clear = true }),
    pattern = disabled_ft,
    callback = function(event)
      vim.b[event.buf].miniindentscope_disable = true
    end,
  })
  -- This runs deferred, so buffers like the dashboard already got their FileType
  -- before the autocmd above existed: disable it for them now.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.tbl_contains(disabled_ft, vim.bo[buf].filetype) or vim.bo[buf].buftype == "terminal" then
      vim.b[buf].miniindentscope_disable = true
    end
  end
  MiniIndentscope.undraw()
  vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("IndentScopeDisableTerm", { clear = true }),
    callback = function(event)
      vim.b[event.buf].miniindentscope_disable = true
    end,
  })
end

return M
