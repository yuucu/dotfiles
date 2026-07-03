return {
  'TheNoeTrevino/haunt.nvim',
  event = 'VeryLazy',
  opts = {
    picker = 'telescope',
    per_branch_bookmarks = true,
  },
  keys = {
    {
      '<leader>ha',
      function()
        require('haunt.api').annotate()
      end,
      desc = 'Haunt Annotate',
    },
    {
      '<leader>hh',
      function()
        require('haunt.picker').show()
      end,
      desc = 'Haunt Picker',
    },
    {
      '<leader>ht',
      function()
        require('haunt.api').toggle_annotation()
      end,
      desc = 'Haunt Toggle',
    },
    {
      '<leader>hd',
      function()
        require('haunt.api').delete()
      end,
      desc = 'Haunt Delete',
    },
  },
}
