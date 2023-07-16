return {
  {
    'vim-jp/vimdoc-ja',
    lazy = true,
    ft = {
      "help",
    },
  },

  -- Git related plugins
  {
    'tpope/vim-fugitive',
    event = "VeryLazy",
  },
  {
    'tpope/vim-rhubarb',
    event = "VeryLazy",
  },

  -- Detect tabstop and shiftwidth automatically
  {
    'tpope/vim-sleuth',
    event = "VeryLazy",
  },

}
