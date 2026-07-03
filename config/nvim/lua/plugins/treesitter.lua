return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  event = { 'BufReadPost', 'BufNewFile' },
  build = ':TSUpdate',
  cmd = { 'TSUpdateSync' },
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
    require('nvim-treesitter').setup({
      ensure_installed = {
        'go',
        'gosum',
        'gomod',
        'gowork',
        'lua',
        'python',
        'rust',
        'typescript',
        'tsx',
        'vimdoc',
        'vim',
        'kotlin',
        'dockerfile',
        'json',
        'json5',
        'jsonc',
        'terraform',
        'hcl',
        'bash',
        'c',
        'html',
        'javascript',
        'jsdoc',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'query',
        'regex',
        'yaml',
        'css',
        'scss',
      },
    })

    -- Diagnostic keymaps
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
  end,
}
