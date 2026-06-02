return{
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "zls","rust_analyzer" },
                automatic_enable = true,
            })

            local border = "rounded"

            vim.o.winborder = border
            vim.diagnostic.config({
                float = { border = border },
            })
        end,
    },
}
