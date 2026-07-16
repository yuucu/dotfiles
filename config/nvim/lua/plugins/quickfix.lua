-- quickfix window enhancements
return {
  {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    event = 'FileType qf',
    config = function()
      require('bqf').setup({
        auto_enable = true,
        func_map = {
          vsplit = '',
        },
      })
    end,
  },
}
