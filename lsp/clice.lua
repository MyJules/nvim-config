-- https://github.com/clice-io/clice
-- Project config: clice.toml or .clice/config.toml. Reads compile_commands.json from the
-- root and its immediate subdirectories (e.g. build/).
return {
  cmd = { "clice", "serve" },
  cmd_env = { CLICE_LOG_LEVEL = "warn" },
  filetypes = { "c", "cpp", "cppm", "cuda", "objc", "objcpp", "opencl", "hip" },
  root_markers = {
    { "clice.toml", ".clice", "compile_commands.json" },
    ".git",
  },
  handlers = {
    -- clice asks for a restart after e.g. switching build configuration.
    ["clice/restartServer"] = function()
      vim.schedule(function()
        vim.cmd("lsp restart clice")
      end)
      return vim.NIL
    end,
  },
}
