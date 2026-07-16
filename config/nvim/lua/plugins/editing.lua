-- editing helpers: search/replace, csv, habit training, diff viewer
return {
  {
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
  },
  {
    'hat0uma/csvview.nvim',
    ft = { 'csv', 'tsv' },
    config = function()
      require('csvview').setup()
      vim.keymap.set('n', '<Space>c', '<cmd>CsvViewToggle<cr>', { desc = 'Toggle CSV view' })
    end,
  },
  {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    opts = {},
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'esmuellert/vscode-diff.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = 'CodeDiff',
  },
}
