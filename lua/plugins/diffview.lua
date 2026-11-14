-- Side-by-side review of every changed file (great for reviewing AI-generated edits).
local M = {}

-- Ask for a message and commit what is staged. With `amend`, rewrite the last commit.
function M.commit(amend)
  local staged = vim.system({ "git", "diff", "--cached", "--quiet" }):wait()
  if staged.code == 0 and not amend then
    vim.notify("Nothing staged to commit", vim.log.levels.WARN)
    return
  end
  local default = ""
  if amend then
    default = vim.trim(vim.system({ "git", "log", "-1", "--format=%B" }, { text = true }):wait().stdout or "")
  end
  vim.ui.input({ prompt = amend and "Amend commit: " or "Commit message: ", default = default }, function(msg)
    if not msg or vim.trim(msg) == "" then
      return
    end
    local cmd = { "git", "commit", "-m", msg }
    if amend then
      table.insert(cmd, "--amend")
    end
    vim.system(cmd, { text = true }, function(res)
      vim.schedule(function()
        if res.code == 0 then
          vim.notify((res.stdout or ""):match("[^\n]+") or "Committed")
        else
          vim.notify(res.stderr ~= "" and res.stderr or res.stdout, vim.log.levels.ERROR)
        end
        if package.loaded["diffview.lib"] and require("diffview.lib").get_current_view() then
          require("diffview.actions").refresh_files()
        end
      end)
    end)
  end)
end

-- Run a git command in the background and report the result.
local function git_async(cmd, label)
  vim.notify(label .. "...")
  vim.system(cmd, { text = true }, function(res)
    vim.schedule(function()
      local out = vim.trim((res.stderr or "") .. "\n" .. (res.stdout or ""))
      if res.code == 0 then
        vim.notify(label .. " done" .. (out ~= "" and (": " .. (out:match("[^\n]+$") or "")) or ""))
      else
        vim.notify(label .. " failed:\n" .. out, vim.log.levels.ERROR)
      end
      if package.loaded["diffview.lib"] and require("diffview.lib").get_current_view() then
        require("diffview.actions").refresh_files()
      end
    end)
  end)
end

function M.push()
  -- First push of a new branch: set its upstream automatically.
  local has_upstream = vim.system({ "git", "rev-parse", "--abbrev-ref", "@{upstream}" }):wait().code == 0
  git_async(has_upstream and { "git", "push" } or { "git", "push", "-u", "origin", "HEAD" }, "Push")
end

function M.pull()
  git_async({ "git", "pull", "--ff-only" }, "Pull")
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
  map("n", "<leader>gl","<Cmd>DiffviewFileHistory --range=@{upstream}..HEAD<CR>", { desc = "Unpushed commits" })
end

return M
