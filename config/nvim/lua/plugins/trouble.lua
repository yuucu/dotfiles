return {
  'folke/trouble.nvim',
  cmd = { 'Trouble' },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    focus = false,
    follow = true,
    auto_preview = true,
    auto_refresh = true,
    modes = {
      diagnostics_buffer = {
        mode = 'diagnostics',
        filter = { buf = 0 },
      },
      diagnostics_errors = {
        mode = 'diagnostics',
        filter = { severity = vim.diagnostic.severity.ERROR },
      },
    },
  },
  keys = {
    {
      '<leader>tt',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
  },
}
