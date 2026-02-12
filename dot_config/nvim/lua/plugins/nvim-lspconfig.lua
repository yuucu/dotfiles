return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'lukas-reineke/lsp-format.nvim',
    'b0o/SchemaStore.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('lsp.common').setup()
  end,
}
