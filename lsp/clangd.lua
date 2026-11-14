return {
  cmd = {
    "clangd",
    "--header-insertion=never",
    "--background-index", -- index the whole project, so references/symbols are complete
    "--clang-tidy", -- lint with the project's .clang-tidy
    "--completion-style=detailed", -- one completion item per overload
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = {
    { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt" },
    ".git",
  },
}
