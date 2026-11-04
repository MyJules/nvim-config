local M = {}

function M.setup()
  local width_file = vim.fn.stdpath("state") .. "\\nvim-tree-width"
  local width = 34
  if vim.uv.fs_stat(width_file) then
    local saved_width = tonumber(vim.fn.readfile(width_file)[1])
    if saved_width and saved_width >= 1 and saved_width % 1 == 0 then
      width = saved_width
    else
      vim.notify("Invalid saved nvim-tree width: " .. width_file, vim.log.levels.WARN)
    end
  end

  local function remember_width()
    local windows = vim.api.nvim_tabpage_list_wins(0)
    if #windows < 2 then
      return
    end
    for _, win in ipairs(windows) do
      if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "NvimTree" then
        local current_width = vim.api.nvim_win_get_width(win)
        if current_width ~= width then
          vim.fn.mkdir(vim.fn.stdpath("state"), "p")
          if vim.fn.writefile({ tostring(current_width) }, width_file) == 0 then
            width = current_width
          else
            vim.notify("Could not save nvim-tree width: " .. width_file, vim.log.levels.ERROR)
          end
        end
        return
      end
    end
  end

  require("nvim-tree").setup({
    hijack_netrw = false,
    view = {
      width = function()
        return width
      end,
      signcolumn = "no",
    },
    renderer = {
      group_empty = true,
      root_folder_label = ":t",
      add_trailing = true,
      highlight_git = "name",
      highlight_opened_files = "name",
      highlight_modified = "name",
      indent_markers = {
        enable = true,
        icons = {
          corner = "`",
          edge = "|",
          item = "|",
          bottom = "-",
          none = " ",
        },
      },
      icons = {
        web_devicons = {
          file = { enable = false },
          folder = { enable = false },
        },
        symlink_arrow = " -> ",
        show = {
          file = false,
          folder = false,
          folder_arrow = false,
          git = false,
          modified = false,
          hidden = false,
          diagnostics = false,
          bookmarks = false,
        },
      },
    },
    modified = { enable = true },
    filters = { dotfiles = false },
    update_focused_file = { enable = true },
  })

  vim.api.nvim_create_autocmd({ "WinResized", "WinLeave", "VimLeavePre" }, {
    group = vim.api.nvim_create_augroup("NvimTreeWidth", { clear = true }),
    callback = remember_width,
  })

  local api = require("nvim-tree.api")
  vim.keymap.set("n", "<leader>e", api.tree.toggle, { desc = "Toggle file tree" })
  vim.keymap.set("n", "<leader>E", function()
    api.tree.find_file({ open = true, focus = true })
  end, { desc = "Reveal current file in tree" })
end

return M
