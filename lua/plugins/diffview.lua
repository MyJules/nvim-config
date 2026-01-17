return {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },

    -- Lazy-load on command
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },

    config = function()
        require("diffview").setup({})
    end,
}
