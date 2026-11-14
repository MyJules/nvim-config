-- Cross-platform path comparison. Windows paths are case-insensitive, so
-- C:\Foo and c:/foo are the same file there; on Linux/macOS case matters.
local M = {}

local ignore_case = vim.fn.has("win32") == 1

-- Normalized form for comparing paths (forward slashes, no trailing slash).
function M.key(path)
  local p = vim.fs.normalize(path)
  return ignore_case and p:lower() or p
end

-- True if `path` is `root` itself or inside it.
function M.is_under(path, root)
  local p, r = M.key(path), M.key(root)
  if p == r then
    return true
  end
  if r:sub(-1) ~= "/" then
    r = r .. "/"
  end
  return p:sub(1, #r) == r
end

-- System temp directory (%TEMP% on Windows, $TMPDIR or /tmp elsewhere).
M.tmpdir = vim.uv.os_tmpdir()

return M
