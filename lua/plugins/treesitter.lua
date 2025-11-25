return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require'nvim-treesitter.configs'.setup {
      ensure_installed = { "lua", "cpp", "zig" },
      highlight = { enable = true },
      indent = { enable = true },
    }
  end
}