vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Skip built-in runtime plugins that aren't used.
for _, plugin in ipairs({
  "netrw",
  "netrwPlugin",
  "gzip",
  "zipPlugin",
  "tarPlugin",
  "tutor_mode_plugin",
  "remote_plugins",
  "spellfile_plugin",
}) do
  vim.g["loaded_" .. plugin] = 1
end
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

local opt = vim.opt
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.termguicolors = true
opt.background = "dark"
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 6
opt.showmode = false
opt.laststatus = 3
opt.showtabline = 2
opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }
opt.pumborder = "rounded"
opt.pumheight = 10
opt.pumwidth = 8
opt.pummaxwidth = 60
opt.winborder = "rounded"
opt.mouse = "a"
opt.fillchars:append({ eob = " " })
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.updatetime = 250
opt.confirm = true
opt.undofile = true
opt.swapfile = false

-- Deferred: setting 'clipboard' can probe for a clipboard provider, which slows startup.
vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)

-- Load trusted project-local .nvim.lua files (Neovim prompts before first use).
opt.exrc = true

-- Use PowerShell 7 for :terminal, :! and system() (see :h shell-powershell).
-- (No executable("pwsh") check: searching PATH costs ~6 ms at startup on Windows.)
if vim.fn.has("win32") == 1 then
  opt.shell = "pwsh"
  opt.shellcmdflag = "-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command "
    .. "[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();"
    .. "$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
    .. "Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
  opt.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  opt.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
  opt.shellquote = ""
  opt.shellxquote = ""
end

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  severity_sort = true,
  float = { source = "if_many" },
  update_in_insert = false,
})
