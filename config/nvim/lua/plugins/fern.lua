return {
  -- file tree
  'lambdalisue/fern.vim',
  event = "VeryLazy",
  dependencies = {
    {
      'lambdalisue/fern-git-status.vim'
    },
    {
      'TheLeoP/fern-renderer-web-devicons.nvim'
    },
  },
  config = function()
    vim.api.nvim_set_keymap('n', '<C-n>', ':Fern . -reveal=% -drawer -toggle -width=40<CR>',
      { noremap = true, silent = true })
    vim.g.fern_renderer = "nvim-web-devicons"
  end,
}
