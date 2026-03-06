-- Function to switch between C++ header and implementation files
local M = {}

function M.switch_cpp_header()
  local current_ext = vim.fn.expand('%:e')
  local filename = vim.fn.expand('%:t:r')
  local current_dir = vim.fn.expand('%:p:h')

  -- Check if clangd is attached and try LSP method
  local clients = vim.lsp.get_clients({bufnr = 0})
  local has_clangd = false
  for _, client in ipairs(clients) do
    if client.name == 'clangd' then
      has_clangd = true
      break
    end
  end

  if has_clangd then
    local ok = pcall(vim.cmd, 'LspClangdSwitchSourceHeader')
    if not ok then
      M.fallback_switch(current_ext, filename, current_dir)
    end
  else
    M.fallback_switch(current_ext, filename, current_dir)
  end
end

function M.fallback_switch(current_ext, filename, current_dir)
  local extensions = {
    cpp = {'hpp', 'h', 'hh'},
    cc = {'hpp', 'h', 'hh'},
    cxx = {'hpp', 'h', 'hh'},
    hpp = {'cpp', 'cc', 'cxx'},
    h = {'cpp', 'cc', 'cxx', 'c'},
    hh = {'cpp', 'cc', 'cxx'}
  }
  
  local target_extensions = extensions[current_ext]
  if not target_extensions then
    print("Not a C/C++ file")
    return
  end
  
  -- Build list of directories to search
  local search_dirs = {current_dir}
  
  -- Common directory mappings
  local dir_replacements = {
    {pattern = '[\\/]src$', replacement = '/inc'},
    {pattern = '[\\/]src[\\/]', replacement = '/inc/'},
    {pattern = '[\\/]inc$', replacement = '/src'},
    {pattern = '[\\/]inc[\\/]', replacement = '/src/'},
    {pattern = '[\\/]source$', replacement = '/include'},
    {pattern = '[\\/]source[\\/]', replacement = '/include/'},
    {pattern = '[\\/]include$', replacement = '/source'},
    {pattern = '[\\/]include[\\/]', replacement = '/source/'},
  }
  
  -- Try directory replacements
  for _, repl in ipairs(dir_replacements) do
    local new_dir = current_dir:gsub(repl.pattern, repl.replacement)
    if new_dir ~= current_dir then
      table.insert(search_dirs, new_dir)
    end
  end
  
  -- Try to find the file
  for _, dir in ipairs(search_dirs) do
    for _, ext in ipairs(target_extensions) do
      local target = dir .. '/' .. filename .. '.' .. ext
      if vim.fn.filereadable(target) == 1 then
        vim.cmd('edit ' .. vim.fn.fnameescape(target))
        return
      end
    end
  end
  
  print("Corresponding file not found for: " .. filename .. "." .. current_ext)
end

return M
