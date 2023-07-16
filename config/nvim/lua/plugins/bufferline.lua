return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    -- { "<S-l>", ":bnext<CR>", desc = "buffer next" },
    -- { "<S-h>", ":bprev<CR>", desc = "buffer prev" },
  },
  config = function()
    local bufferline = require('bufferline')
    require("bufferline").setup {
      options = {
        diagnostics = "nvim_lsp",
        style_preset = bufferline.style_preset.minimal,
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = false,
      }
    }
  end
}
