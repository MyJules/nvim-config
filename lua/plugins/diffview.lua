-- Side-by-side review of every changed file (great for reviewing AI-generated edits).
local M = {}

-- Repo to run git in: the open diffview's repo, else the current file's, else the cwd.
local function repo_root()
  local ok, view = pcall(function()
    return package.loaded["diffview.lib"] and require("diffview.lib").get_current_view()
  end)
  if ok and view and view.adapter then
    return view.adapter.ctx.toplevel
  end
  return vim.fs.root(0, ".git") or vim.fn.getcwd()
end

-- Run `git <args>` in the repo. With `on_exit` it runs in the background.
local function git(args, on_exit)
  return vim.system(vim.list_extend({ "git" }, args), { text = true, cwd = repo_root() }, on_exit)
end

local function refresh_diffview()
  if package.loaded["diffview.lib"] and require("diffview.lib").get_current_view() then
    require("diffview.actions").refresh_files()
  end
end

-- Run a git command in the background and report the result.
local function git_async(args, label)
  vim.notify(label .. "...")
  git(args, function(res)
    vim.schedule(function()
      local out = vim.trim((res.stderr or "") .. "\n" .. (res.stdout or ""))
      if res.code == 0 then
        vim.notify(label .. " done" .. (out ~= "" and (": " .. (out:match("[^\n]+$") or "")) or ""))
      else
        vim.notify(label .. " failed:\n" .. out, vim.log.levels.ERROR)
      end
      refresh_diffview()
    end)
  end)
end

-- Ask for a message and commit what is staged. With `amend`, rewrite the last commit.
function M.commit(amend)
  local staged = git({ "diff", "--cached", "--quiet" }):wait()
  if staged.code == 0 and not amend then
    vim.notify("Nothing staged to commit", vim.log.levels.WARN)
    return
  end
  -- The prompt is a single line, so only the subject is edited there. An amend
  -- keeps the original body (and trailers like Co-Authored-By) as a second paragraph.
  local subject, body = "", ""
  if amend then
    subject = vim.trim(git({ "log", "-1", "--format=%s" }):wait().stdout or "")
    body = vim.trim(git({ "log", "-1", "--format=%b" }):wait().stdout or "")
  end
  vim.ui.input({ prompt = amend and "Amend commit: " or "Commit message: ", default = subject }, function(msg)
    if not msg or vim.trim(msg) == "" then
      return
    end
    local args = { "commit", "-m", msg }
    if amend then
      table.insert(args, "--amend")
      if body ~= "" then
        vim.list_extend(args, { "-m", body })
      end
    end
    git(args, function(res)
      vim.schedule(function()
        if res.code == 0 then
          vim.notify((res.stdout or ""):match("[^\n]+") or "Committed")
        else
          vim.notify(res.stderr ~= "" and res.stderr or res.stdout, vim.log.levels.ERROR)
        end
        refresh_diffview()
      end)
    end)
  end)
end

local function has_upstream()
  return git({ "rev-parse", "--abbrev-ref", "@{upstream}" }):wait().code == 0
end

function M.push()
  -- First push of a new branch: set its upstream automatically.
  git_async(has_upstream() and { "push" } or { "push", "-u", "origin", "HEAD" }, "Push")
end

function M.pull()
  git_async({ "pull", "--ff-only" }, "Pull")
end

function M.unpushed()
  if not has_upstream() then
    vim.notify("Branch has no upstream yet (push it first)", vim.log.levels.WARN)
    return
  end
  vim.cmd("DiffviewFileHistory --range=@{upstream}..HEAD")
end

-- Neovim inherits PATH from whatever launched it, so a freshly installed lazygit
-- may be missing until that app restarts. Fall back to winget's install folder.
local function find_lazygit()
  if vim.fn.executable("lazygit") == 1 then
    return true
  end
  if vim.fn.has("win32") == 1 and vim.env.LOCALAPPDATA then
    local dir = vim.fs.joinpath(vim.env.LOCALAPPDATA, "Microsoft", "WinGet", "Packages")
    for name in vim.fs.dir(dir) do
      if vim.startswith(name, "JesseDuffield.lazygit") then
        vim.env.PATH = vim.fs.joinpath(dir, name) .. ";" .. vim.env.PATH
        return vim.fn.executable("lazygit") == 1
      end
    end
  end
  return false
end

function M.lazygit(view)
  if not find_lazygit() then
    vim.notify("lazygit not found (install it: winget install JesseDuffield.lazygit)", vim.log.levels.ERROR)
    return
  end
  if view then
    Snacks.lazygit[view]()
  else
    Snacks.lazygit()
  end
end

function M.setup()
  local actions = require("diffview.actions")
  local commit = { "n", "cc", function() M.commit(false) end, { desc = "Commit staged" } }
  local amend = { "n", "ca", function() M.commit(true) end, { desc = "Amend last commit" } }

  require("diffview").setup({
    enhanced_diff_hl = true, -- highlight changed words inside changed lines
    show_help_hints = true,
    view = {
      default = { layout = "diff2_horizontal", winbar_info = true },
      file_history = { layout = "diff2_horizontal", winbar_info = true },
      merge_tool = { layout = "diff3_horizontal", disable_diagnostics = true },
    },
    file_panel = {
      listing_style = "tree",
      win_config = { position = "left", width = 34 },
    },
    keymaps = {
      view = {
        { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
        { "n", "]f", actions.select_next_entry, { desc = "Next file" } },
        { "n", "[f", actions.select_prev_entry, { desc = "Previous file" } },
      },
      file_panel = {
        { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
        commit,
        amend,
      },
      file_history_panel = {
        { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
      },
    },
  })

  local map = vim.keymap.set
  map("n", "<leader>gv", "<Cmd>DiffviewOpen<CR>", { desc = "Review all changes (diffview)" })
  map("n", "<leader>gV", "<Cmd>DiffviewOpen HEAD~1<CR>", { desc = "Review last commit" })
  map("n", "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", { desc = "File history" })
  map("n", "<leader>gH", "<Cmd>DiffviewFileHistory<CR>", { desc = "Repo history" })
  map("x", "<leader>gh", ":DiffviewFileHistory<CR>", { desc = "History of selection" })
  map("n", "<leader>gc", function() M.commit(false) end, { desc = "Commit staged" })
  map("n", "<leader>gC", function() M.commit(true) end, { desc = "Amend last commit" })
  map("n", "<leader>gP", M.push, { desc = "Push" })
  map("n", "<leader>gF", M.pull, { desc = "Pull (fast-forward only)" })
  map("n", "<leader>gl", M.unpushed, { desc = "Unpushed commits" })
  -- lazygit in a float (snacks): rebase, branches, stash, cherry-pick, conflicts.
  map("n", "<leader>gg", function() M.lazygit() end, { desc = "Lazygit" })
  map("n", "<leader>gL", function() M.lazygit("log_file") end, { desc = "Lazygit file log" })
end

return M
