return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'VeryLazy',
  priority = 1000,
  config = function()
    require('tiny-inline-diagnostic').setup({
      preset = 'modern',
      options = {
        show_source = {
          enabled = true,
          if_many = true,
        },
        multilines = {
          enabled = true,
          always_show = false,
        },
      },
    })
  end,
}
