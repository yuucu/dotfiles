-- Git related plugins
return {
  {
    'tpope/vim-fugitive',
    event = { 'BufReadPre', 'BufNewFile' },
    cond = function()
      return not vim.g.vscode
    end,
    dependencies = {
      'tpope/vim-rhubarb',
    },
  },
}
