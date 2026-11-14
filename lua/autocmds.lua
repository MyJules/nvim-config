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

-- Reload files changed outside Neovim (e.g. by an AI agent) --------------------
-- Two triggers: a cheap check whenever focus/buffer changes, plus a filesystem
-- watcher per open file so edits show up even while Neovim keeps focus
-- (agent running in a terminal split). Buffers with unsaved changes are never
-- overwritten silently: Neovim asks what to do.
vim.o.autoread = true

local function checktime(buf)
  -- :checktime is not allowed in the cmdline window or while typing a command.
  if vim.fn.getcmdwintype() ~= "" or vim.fn.mode():find("^c") then
    return
  end
  if buf then
    if vim.api.nvim_buf_is_valid(buf) then
      vim.cmd.checktime(buf)
    end
  else
    vim.cmd.checktime()
  end
end

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave", "TermClose" }, {
  group = augroup("AutoReload"),
  desc = "Check open files for changes on disk",
  callback = function()
    checktime()
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = augroup("AutoReloadNotify"),
  desc = "Say which file was reloaded",
  callback = function(event)
    vim.notify("Reloaded " .. vim.fn.fnamemodify(event.file, ":~:."), vim.log.levels.INFO)
  end,
})

local watchers = {} -- buf -> uv_fs_event
local pending = {} -- buf -> debounce timer

local function unwatch(buf)
  if watchers[buf] then
    watchers[buf]:stop()
    watchers[buf]:close()
    watchers[buf] = nil
  end
  if pending[buf] then
    pending[buf]:stop()
    pending[buf]:close()
    pending[buf] = nil
  end
end

local function watch(buf)
  unwatch(buf)
  if vim.bo[buf].buftype ~= "" then
    return
  end
  local file = vim.api.nvim_buf_get_name(buf)
  if file == "" or vim.fn.filereadable(file) ~= 1 then
    return
  end
  local w = vim.uv.new_fs_event()
  if not w then
    return
  end
  local ok = w:start(file, {}, function()
    -- Editors and agents often write in bursts (or replace the file), so wait
    -- for things to settle, then re-check and re-arm the watcher.
    local t = pending[buf]
    if not t then
      t = vim.uv.new_timer()
      pending[buf] = t
    end
    t:stop()
    t:start(150, 0, vim.schedule_wrap(function()
      if not vim.api.nvim_buf_is_valid(buf) then
        return unwatch(buf)
      end
      checktime(buf)
      watch(buf)
    end))
  end)
  if ok then
    watchers[buf] = w
  else
    w:close()
  end
end

local watch_group = augroup("AutoReloadWatch")
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "BufFilePost" }, {
  group = watch_group,
  callback = function(event)
    watch(event.buf)
  end,
})
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = watch_group,
  callback = function(event)
    unwatch(event.buf)
  end,
})
