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
-- nvim-treesitter loads deferred; until then keep the current line's indent
-- instead of erroring on a missing module.
function M.indentexpr()
  local ts = package.loaded["nvim-treesitter"]
  return ts and ts.indentexpr() or -1
end

-- Folds are window-local: set them on the windows showing `buf`, not whatever
-- window happens to be current (e.g. a picker prompt during previews).
local function set_folds(buf)
  if not vim.treesitter.highlighter.active[buf] then
    return
  end
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.wo[win][0].foldmethod = "expr"
    vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end
end

function M.setup()
  vim.opt.foldlevelstart = 99 -- treesitter folds, but start with everything open

  local group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(event)
      local lang = vim.treesitter.language.get_lang(event.match)
      if not lang or not pcall(vim.treesitter.language.add, lang) then
        return
      end
      if not pcall(vim.treesitter.start, event.buf, lang) then
        return
      end
      vim.bo[event.buf].indentexpr = "v:lua.require'plugins.treesitter'.indentexpr()"
      set_folds(event.buf)
    end,
  })
  -- Buffers shown in a window after their FileType fired (splits, previews).
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    callback = function(event)
      set_folds(event.buf)
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
