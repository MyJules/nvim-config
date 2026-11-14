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

-- Highlighting and folds use Neovim's built-in treesitter and the installed parsers
-- (in stdpath("data")/site), so this runs at startup without loading nvim-treesitter.
function M.setup()
  vim.opt.foldlevelstart = 99 -- treesitter folds, but start with everything open

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
    callback = function(event)
      local lang = vim.treesitter.language.get_lang(event.match)
      if not lang or not pcall(vim.treesitter.language.add, lang) then
        return
      end
      if not pcall(vim.treesitter.start, event.buf, lang) then
        return
      end
      vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo[0][0].foldmethod = "expr"
      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
  })
end

-- nvim-treesitter itself is only needed for indentexpr and installing parsers.
function M.setup_deferred()
  local ts = require("nvim-treesitter")
  ts.setup()

  local installed = ts.get_installed()
  local missing = vim.tbl_filter(function(lang)
    return not vim.tbl_contains(installed, lang)
  end, M.parsers)
  if #missing > 0 then
    ts.install(missing)
  end
end

return M
