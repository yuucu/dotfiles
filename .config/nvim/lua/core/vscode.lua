local opts = { noremap = true }
vim.keymap.set('n', ';', ':', opts)
vim.keymap.set('n', ':', ';', opts)

vim.o.clipboard = 'unnamedplus'
