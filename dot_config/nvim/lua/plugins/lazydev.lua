return {
  'folke/lazydev.nvim',
  ft = 'lua', -- Lua ファイルでのみ読み込む（重要）
  opts = {
    library = {
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
    },
  },
}
