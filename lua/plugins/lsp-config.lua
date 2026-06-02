return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-org/mason.nvim",
        },
        config = function()
            local border = "rounded"
            local servers = { "lua_ls", "zls", "rust_analyzer" }

            vim.o.winborder = border
            vim.diagnostic.config({
                float = { border = border },
            })

            local registry = require("mason-registry")

            registry.refresh(function(success)
                if not success then
                    vim.notify("Failed to refresh Mason registry.", vim.log.levels.WARN)
                    return
                end

                local lspconfig_to_package = {}
                for _, pkg_spec in ipairs(registry.get_all_package_specs()) do
                    local server = vim.tbl_get(pkg_spec, "neovim", "lspconfig")
                    if server then
                        lspconfig_to_package[server] = pkg_spec.name
                    end
                end

                for _, server in ipairs(servers) do
                    local package_name = lspconfig_to_package[server]
                    if not package_name then
                        vim.notify(("Mason package not found for LSP server: %s"):format(server), vim.log.levels.WARN)
                    else
                        local pkg = registry.get_package(package_name)
                        if not pkg:is_installed() then
                            pkg:install()
                        end
                    end
                end
            end)

            vim.lsp.enable(servers)
        end,
    },
}
