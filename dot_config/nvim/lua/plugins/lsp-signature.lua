return {
  'ray-x/lsp_signature.nvim',
  event = 'LspAttach',
  opts = {
    bind = true,
    handler_opts = { border = 'rounded' },
    hint_enable = true,
    hint_prefix = '🐼 ',
    max_height = 12,
    max_width = 80,
    floating_window_above_cur_line = true,
    timer_interval = 200,
  },
}
