return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'saghen/blink.cmp',
    'b0o/SchemaStore.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('lsp.common').setup()
  end,
}
