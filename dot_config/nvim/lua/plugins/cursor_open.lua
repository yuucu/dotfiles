return {
  'yuucu/cursor_open.nvim',
  cmd = { 'CursorOpen' },
  keys = {
    { '<leader>oc', ':CursorOpen<CR>', desc = '[O]pen in [C]ursor' },
    { '<leader>oC', ':CursorOpen!<CR>', desc = '[O]pen in new [C]ursor window' },
  },
  config = function()
    require('cursor_open').setup()
  end
}
