vim.loader.enable()

require("options")
require("keymaps")
require("autocmds")
require("plugins").setup()
require("lsp")
