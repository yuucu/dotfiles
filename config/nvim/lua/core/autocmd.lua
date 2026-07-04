-- ファイルを開いた時に、カーソルの場所を復元する
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    vim.cmd([[silent! normal! g`"zv]])
  end,
})

-- ヤンク時にハイライト
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- 拡張子ベースのファイルタイプ判定
vim.filetype.add({
  extension = {
    mdc = 'markdown',
    puml = 'plantuml',
    plantuml = 'plantuml',
    pu = 'plantuml',
    uml = 'plantuml',
    gd = 'gdscript',
  },
})
