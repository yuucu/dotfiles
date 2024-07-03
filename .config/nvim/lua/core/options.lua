-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- :help options
vim.opt.backup = false -- creates a backup file

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- vim doc ja
vim.o.helplang = 'ja,en'

-- tab
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- other
vim.o.autoread = true
vim.o.incsearch = true
vim.o.autoindent = true
vim.o.laststatus = 2

vim.cmd("set t_Co=256")
