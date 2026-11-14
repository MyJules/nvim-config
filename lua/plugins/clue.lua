local M = {}

function M.setup()
  local miniclue = require("mini.clue")
  miniclue.setup({
    triggers = {
      { mode = { "n", "x" }, keys = "<Leader>" },
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },
      { mode = "i", keys = "<C-x>" },
      { mode = { "n", "x" }, keys = "g" },
      { mode = { "n", "x" }, keys = "'" },
      { mode = { "n", "x" }, keys = "`" },
      { mode = { "n", "x" }, keys = '"' },
      { mode = { "i", "c" }, keys = "<C-r>" },
      { mode = "n", keys = "<C-w>" },
      { mode = { "n", "x" }, keys = "z" },
    },
    clues = {
      { mode = "n", keys = "<Leader>b", desc = "+Buffers" },
      { mode = "n", keys = "<Leader>f", desc = "+Find" },
      { mode = { "n", "x" }, keys = "<Leader>g", desc = "+Git" },
      { mode = { "n", "x" }, keys = "<Leader>l", desc = "+LSP" },
      { mode = "n", keys = "<Leader>s", desc = "+Startup" },
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
    window = {
      delay = 300,
      config = { border = "rounded" },
    },
  })
end

return M
