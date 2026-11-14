local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("HighlightYank"),
  desc = "Briefly highlight yanked text",
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("RestoreCursor"),
  desc = "Jump to the last cursor position when reopening a file",
  callback = function(event)
    local ft = vim.bo[event.buf].filetype
    if ft == "gitcommit" or ft == "gitrebase" then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(event.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("BalanceSplits"),
  desc = "Equalize splits when the terminal is resized",
  command = "tabdo wincmd =",
})

-- Keep v:oldfiles current within the session so the recent files picker
-- reflects files opened since startup, not just those from the last shada write.
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("RecentFiles"),
  callback = function(event)
    if vim.bo[event.buf].buftype ~= "" then
      return
    end

    local file = vim.api.nvim_buf_get_name(event.buf)
    if vim.fn.filereadable(file) ~= 1 then
      return
    end

    local key = function(path)
      return vim.fs.normalize(path):lower()
    end
    local recent = vim.tbl_filter(function(path)
      return key(path) ~= key(file)
    end, vim.v.oldfiles)
    table.insert(recent, 1, file)
    vim.v.oldfiles = recent
  end,
})
