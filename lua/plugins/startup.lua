local M = {}

function M.setup()
  require("startup").setup({
    header = {
      type = "text",
      align = "center",
      highlight = "StartupLogo",
      content = {
        [[ _   _ _____ _____     _____ __  __ ]],
        [[| \ | | ____/ _ \ \   / /_ _|  \/  |]],
        [[|  \| |  _|| | | \ \ / / | || |\/| |]],
        [[| |\  | |__| |_| |\ V /  | || |  | |]],
        [[|_| \_|_____\___/  \_/  |___|_|  |_|]],
      },
    },
    tagline = {
      type = "text",
      align = "center",
      highlight = "StartupMuted",
      content = { "A quiet place to build." },
    },
    actions = {
      type = "mapping",
      align = "center",
      highlight = "StartupActions",
      content = {
        { "Find files", "Telescope find_files", "f" },
        { "Recent files", "Telescope oldfiles", "r" },
        { "New file", "enew", "n" },
        { "Explore files", "NvimTreeOpen", "e" },
        { "Quit", "qa", "q" },
      },
    },
    footer = {
      type = "text",
      align = "center",
      highlight = "StartupMuted",
      content = function()
        return {
          vim.fn.fnamemodify(vim.fn.getcwd(), ":~"),
        }
      end,
    },
    hints = {
      type = "text",
      align = "center",
      highlight = "StartupHint",
      content = { "ENTER  select     /     ?  help" },
    },
    options = {
      mapping_keys = true,
      empty_lines_between_mappings = false,
      paddings = { 2, 1, 2, 2, 1 },
    },
    parts = { "header", "tagline", "actions", "footer", "hints" },
  })

  vim.keymap.set("n", "<leader>sd", "<cmd>Startup display<CR>", { desc = "Open startup dashboard" })
end

return M
