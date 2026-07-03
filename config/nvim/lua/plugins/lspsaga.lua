return {
  'nvimdev/lspsaga.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
    require('lspsaga').setup({
      ui = { title = false, border = 'single' },
      symbol_in_winbar = { enable = true },
      code_action_lightbulb = { enable = true },
      show_outline = { win_width = 50, auto_preview = false },
    })

    local maps = {
      gh = 'Lspsaga finder',
      ga = 'Lspsaga code_action',
      gp = 'Lspsaga peek_definition',
      ['<leader>sl'] = 'Lspsaga show_line_diagnostics',
      ['<leader>sb'] = 'Lspsaga show_buf_diagnostics',
      ['<leader>sw'] = 'Lspsaga show_workspace_diagnostics',
      ['<leader>sc'] = 'Lspsaga show_cursor_diagnostics',
      ['g]'] = 'Lspsaga diagnostic_jump_next',
      ['g['] = 'Lspsaga diagnostic_jump_prev',
      ['<leader>o'] = 'Lspsaga outline',
      K = 'Lspsaga hover_doc ++keep',
      ['<Leader>ci'] = 'Lspsaga incoming_calls',
      ['<Leader>co'] = 'Lspsaga outgoing_calls',
      ['<Leader>t'] = 'Lspsaga term_toggle',
    }

    for key, cmd in pairs(maps) do
      local mode = key == 'ga' and { 'n', 'v' } or 'n'
      vim.keymap.set(mode, key, '<cmd>' .. cmd .. '<CR>')
    end
  end,
}
