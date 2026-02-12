-- Tailwind CSS の補完とハイライト
return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      {
        'luckasRanarison/tailwind-tools.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = {
          -- Tailwind CSS の色プレビュー
          document_color = {
            enabled = true,
            kind = 'inline',
            inline_symbol = '󰝤 ',
          },
          -- クラス名の補完と並び替え
          conceal = {
            enabled = false, -- クラス名を短縮表示しない
          },
        },
      },
    },
  },
  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      user_default_options = {
        tailwind = true, -- Tailwind クラス名の色表示
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
      },
    },
  },
}
