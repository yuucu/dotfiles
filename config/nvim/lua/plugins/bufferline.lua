return {
  'akinsho/bufferline.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
    vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})
    local bufferline = require('bufferline')
    require("bufferline").setup {
      options = {
        -- mode = "tabs",
        style_preset = bufferline.style_preset.minimal,
        always_show_bufferline = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        diagnostics = "nvim_lsp",
      },
    }
  end
}
