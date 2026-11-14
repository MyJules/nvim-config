local M = {}

function M.setup()
  -- Command box and its completion list share a width and column, and the list's
  -- top border sits on the box's bottom border, so the two read as one panel.
  local width = 64
  local function popup_row()
    return math.max(2, math.floor(vim.o.lines * 0.25))
  end
  local row = popup_row()

  require("noice").setup({
    cmdline = {
      view = "cmdline_popup",
      -- Icons as escapes so editors/tools can't strip the Nerd Font glyphs.
      format = {
        cmdline = { pattern = "^:", icon = "\u{f054}", lang = "vim", title = " Command " },
        search_down = { kind = "search", pattern = "^/", icon = "\u{f002} \u{f063}", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = "\u{f002} \u{f062}", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash", title = " Shell " },
        lua = {
          pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
          icon = "\u{e620}",
          lang = "lua",
          title = " Lua ",
        },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "\u{f02d6}", title = " Help " },
        input = { view = "cmdline_input", icon = "\u{f097b} " },
      },
    },
    popupmenu = { backend = "nui" },
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
    },
    views = {
      cmdline_popup = {
        relative = "editor",
        position = { row = row, col = "50%" },
        size = { width = width, height = "auto" },
        border = { style = "rounded", padding = { 0, 1 } },
      },
      cmdline_popupmenu = {
        relative = "editor",
        -- Box = top border, input line, bottom border; overlap that bottom border.
        position = { row = row + 2, col = "50%" },
        size = { width = width, height = "auto", max_height = 10 },
        zindex = 250, -- above the command box (200)
        border = {
          style = { "├", "─", "┤", "│", "╯", "─", "╰", "│" },
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal = "NoiceCmdlinePopup",
            FloatBorder = "NoiceCmdlinePopupBorder",
            CursorLine = "PmenuSel",
            PmenuMatch = "NoiceCmdlineIcon",
          },
        },
      },
    },
  })

  -- Keep the box a quarter of the way down after the terminal is resized
  -- (noice builds a new view when its options change).
  vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("NoiceCmdlineRow", { clear = true }),
    callback = function()
      local views = require("noice.config").options.views
      local r = popup_row()
      views.cmdline_popup.position.row = r
      views.cmdline_popupmenu.position.row = r + 2
    end,
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
