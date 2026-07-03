return {
  'VidocqH/lsp-lens.nvim',
  enabled = true,
  event = 'LspAttach',
  config = function()
    require('lsp-lens').setup(require('lsp.common').lens_opts())
  end,
}
