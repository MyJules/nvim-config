return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    { ".luarc.json", ".luarc.jsonc", ".emmyrc.json" },
    ".git",
  },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  -- In the Neovim config (or any project without its own .luarc), teach lua_ls
  -- about the Neovim runtime so `vim.*` is typed and not flagged as undefined.
  on_init = function(client)
    local root = client.workspace_folders and client.workspace_folders[1].name
    if root and (vim.uv.fs_stat(root .. "/.luarc.json") or vim.uv.fs_stat(root .. "/.luarc.jsonc")) then
      return
    end
    client.config.settings.Lua.workspace.library = {
      vim.env.VIMRUNTIME,
      "${3rd}/luv/library",
    }
    client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end,
}
