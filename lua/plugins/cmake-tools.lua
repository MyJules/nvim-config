return {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("cmake-tools").setup({
            cmake_command = "cmake",
            cmake_build_directory = "build",
            cmake_generate_options = {
                "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
                "-DCMAKE_BUILD_TYPE=Debug",
            },
            cmake_build_options = { "--parallel" },
            cmake_console_size = 10,
            cmake_console_position = "belowright",
            cmake_show_console = "always",
        })

        -- Keymaps
        local map = vim.keymap.set
        map("n", "<leader>cg", "<cmd>CMakeGenerate<cr>",  { desc = "CMake: Configure" })
        map("n", "<leader>cb", "<cmd>CMakeBuild<cr>",     { desc = "CMake: Build" })
        map("n", "<leader>cr", "<cmd>CMakeRun<cr>",       { desc = "CMake: Run target" })
        map("n", "<leader>ct", "<cmd>CMakeSelectBuildTarget<cr>", { desc = "CMake: Select target" })
        map("n", "<leader>cx", "<cmd>CMakeClean<cr>",     { desc = "CMake: Clean" })
    end,
}
