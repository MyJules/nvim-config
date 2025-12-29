return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("dashboard").setup({
      theme = "hyper",
      config = {
        -- Header
        header = {
          "",
          " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
          " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
          " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
          " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
          " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
          " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
          ""
        },

        -- Center menu
        center = {
          {
            icon = "󰈞 ",
            desc = "Find File",
            key = "f",
            action = "Telescope find_files",
          },
          {
            icon = " ",
            desc = "New File",
            key = "n",
            action = "ene | startinsert",
          },
          {
            icon = "󰄉 ",
            desc = "Recent Files",
            key = "r",
            action = "Telescope oldfiles",
          },
          {
            icon = "󰱼 ",
            desc = "Find Text",
            key = "g",
            action = "Telescope live_grep",
          },
          {
            icon = " ",
            desc = "Config",
            key = "c",
            action = "edit ~/.config/nvim/init.lua",
          },
          {
            icon = "󰅚 ",
            desc = "Quit",
            key = "q",
            action = "qa",
          },
        },
      },
    })
  end,
}
