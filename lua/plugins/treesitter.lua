local M = {}

M.parsers = {
  "c",
  "cpp",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "markdown",
  "markdown_inline",
  "json",
  "cmake",
  "bash",
  "powershell",
}

function M.setup()
  local ts = require("nvim-treesitter")
  ts.setup()
  -- No-op for parsers that are already installed; runs asynchronously otherwise.
  ts.install(M.parsers)

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
    callback = function(event)
      local lang = vim.treesitter.language.get_lang(event.match)
      if not lang or not vim.treesitter.language.add(lang) then
        return
      end
      vim.treesitter.start(event.buf, lang)
      vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo[0][0].foldmethod = "expr"
      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
  })

  -- Treesitter folds, but start with everything open.
  vim.opt.foldlevelstart = 99
end

return M
