-- Server configs live in lsp/<name>.lua. Completion capabilities are added by blink.cmp.
-- Built-in defaults (0.12): K hover, grn rename, gra code action, grr references,
-- gri implementation, gO document symbols, [d / ]d diagnostics, <C-s> signature help.

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("LspAttach"),
  callback = function(event)
    local buf = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map({ "n", "x" }, "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format buffer")
    map("n", "<leader>lr", vim.lsp.buf.rename, "Rename symbol")
    map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, "Code action")

    if client:supports_method("textDocument/inlayHint", buf) then
      map("n", "<leader>lh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
      end, "Toggle inlay hints")
    end

    if client.name == "clangd" then
      map("n", "<leader>ls", function()
        local params = vim.lsp.util.make_text_document_params(buf)
        client:request("textDocument/switchSourceHeader", params, function(err, result)
          if err then
            vim.notify(err.message, vim.log.levels.ERROR)
          elseif not result then
            vim.notify("No matching source/header file", vim.log.levels.WARN)
          else
            vim.cmd.edit(vim.fn.fnameescape(vim.uri_to_fname(result)))
          end
        end, buf)
      end, "Switch source/header")
    end

    -- Highlight other references to the symbol under the cursor.
    if client:supports_method("textDocument/documentHighlight", buf) then
      local group = vim.api.nvim_create_augroup("LspDocumentHighlight." .. buf, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = group,
        buffer = buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
        group = group,
        buffer = buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = augroup("LspDetach"),
  callback = function(event)
    local buf = event.buf
    -- Keep highlighting if another attached client still provides it.
    for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
      if c.id ~= event.data.client_id and c:supports_method("textDocument/documentHighlight", buf) then
        return
      end
    end
    vim.lsp.util.buf_clear_references(buf)
    pcall(vim.api.nvim_del_augroup_by_name, "LspDocumentHighlight." .. buf)
  end,
})

vim.lsp.enable({ "clangd", "lua_ls" })
