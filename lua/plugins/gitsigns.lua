local M = {}

function M.setup()
  require("gitsigns").setup({
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    preview_config = { border = "rounded" },
    on_attach = function(buf)
      local gs = require("gitsigns")
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
      end

      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next git hunk")
      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Previous git hunk")

      map("n", "<leader>gs", gs.stage_hunk, "Stage/unstage hunk")
      map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
      map("x", "<leader>gs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage/unstage selection")
      map("x", "<leader>gr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset selection")
      map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
      map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
      map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
      map("n", "<leader>gb", function()
        gs.blame_line({ full = true })
      end, "Blame line")
      map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle inline blame")
      map("n", "<leader>gd", gs.diffthis, "Diff against index")
      map("n", "<leader>gi", gs.preview_hunk_inline, "Preview hunk inline")
      map("n", "<leader>gw", function()
        -- Inline review mode: show deleted lines and word-level changes in the buffer.
        gs.toggle_word_diff()
        gs.toggle_deleted()
        gs.toggle_linehl()
      end, "Toggle inline diff")
      map("n", "<leader>gq", function()
        gs.setqflist("all")
      end, "All hunks to quickfix")

      map({ "o", "x" }, "ih", gs.select_hunk, "Inside git hunk")
    end,
  })
end

return M
