return {
  'greggh/claude-code.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  cmd = 'ClaudeCode',
  config = function()
    require('claude-code').setup()
  end,
}
