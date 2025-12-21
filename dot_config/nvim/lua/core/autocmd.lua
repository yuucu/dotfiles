-- ファイルを開いた時に、カーソルの場所を復元する
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- ヤンク時にハイライト
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- ファイルタイプ設定
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.mdc',
  callback = function()
    vim.bo.filetype = 'markdown'
  end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.puml', '*.plantuml', '*.pu', '*.uml' },
  callback = function()
    vim.bo.filetype = 'plantuml'
  end,
})

-- FileType 固有の設定
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'mdc' },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})
