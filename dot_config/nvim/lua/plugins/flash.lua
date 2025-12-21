return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {
    labels = 'asdfghjklqwertyuiopzxcvbnm',
    search = {
      multi_window = false,
      forward = true,
      wrap = true,
      mode = 'exact',
    },
    jump = {
      jumplist = true,
      pos = 'start',
      history = false,
      register = false,
      nohlsearch = true,
      autojump = false,
    },
    label = {
      uppercase = true,
      rainbow = {
        enabled = false,
        shade = 5,
      },
    },
    modes = {
      search = {
        enabled = true,
      },
      char = {
        enabled = true,
        jump_labels = true,
        multi_line = true,
      },
    },
  },
  keys = {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
    {
      'S',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flash Treesitter',
    },
    {
      'R',
      mode = { 'o', 'x' },
      function()
        require('flash').treesitter_search()
      end,
      desc = 'Treesitter Search',
    },
    {
      '<c-s>',
      mode = { 'c' },
      function()
        require('flash').toggle()
      end,
      desc = 'Toggle Flash Search',
    },
  },
}
