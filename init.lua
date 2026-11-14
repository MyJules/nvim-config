vim.g.start_time = vim.uv.hrtime()
vim.loader.enable()

require("options")
require("keymaps")
require("autocmds")
require("plugins").setup() -- also loads lsp.lua once the UI is up
