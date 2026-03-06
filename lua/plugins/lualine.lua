return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local mode_map = {
      ['NORMAL']   = 'N  NORMAL',
      ['INSERT']   = 'I  INSERT',
      ['VISUAL']   = 'V  VISUAL',
      ['V-LINE']   = 'VL V-LINE',
      ['V-BLOCK']  = 'VB V-BLOCK',
      ['COMMAND']  = 'C  COMMAND',
      ['TERMINAL'] = 'T  TERMINAL',
      ['REPLACE']  = 'R  REPLACE',
    }

    require('lualine').setup {
      options = {
        theme = 'material',
        component_separators = { left = '|', right = '|' },
        section_separators   = { left = '', right = '' },
        globalstatus = true,
        disabled_filetypes = {
          statusline = { 'neo-tree', 'alpha', 'dashboard' },
        },
      },
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(str) return mode_map[str] or str end,
            padding = { left = 2, right = 2 },
          },
        },
        lualine_b = {
          { 'branch', icon = '', padding = { left = 2, right = 1 } },
          {
            'diff',
            symbols = { added = '+', modified = '~', removed = '-' },
            colored = true,
            padding = { left = 1, right = 2 },
          },
        },
        lualine_c = {
          {
            'filename',
            path = 1,
            symbols = {
              modified = ' [+]',
              readonly = ' [-]',
              unnamed  = '[No Name]',
            },
            padding = { left = 2, right = 2 },
          },
        },
        lualine_x = {
          {
            'diagnostics',
            sources = { 'nvim_lsp' },
            symbols = { error = 'E:', warn = 'W:', info = 'I:', hint = 'H:' },
            colored = true,
            padding = { left = 2, right = 1 },
          },
          { 'encoding', padding = { left = 1, right = 1 } },
          {
            'filetype',
            icon_only = false,
            padding = { left = 1, right = 2 },
          },
        },
        lualine_y = {
          { 'progress', padding = { left = 2, right = 1 } },
        },
        lualine_z = {
          { 'location', padding = { left = 1, right = 2 } },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1, padding = { left = 2, right = 2 } } },
        lualine_x = { { 'location', padding = { left = 2, right = 2 } } },
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
}

