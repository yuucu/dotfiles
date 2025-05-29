return {
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('treesj').setup({})
    vim.keymap.set('n', '<leader>s', require('treesj').toggle)
  end,
}
