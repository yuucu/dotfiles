-- Tailwind CSS の補完とハイライト
return {
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
