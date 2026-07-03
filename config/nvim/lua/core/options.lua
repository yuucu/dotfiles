-- [[ Setting options ]]

local opt = vim.opt

-- Backup and undo
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- UI
opt.number = true
opt.relativenumber = false
opt.signcolumn = 'yes'
opt.cursorline = true
opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.laststatus = 2

-- Editing
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.breakindent = true
opt.autoindent = true
opt.smartindent = true
opt.wrap = false

-- Tab and indentation
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.lazyredraw = true

-- Other
opt.autoread = true
opt.helplang = 'ja,en'
opt.completeopt = 'menu,menuone,noselect'
opt.conceallevel = 0
opt.fileencoding = 'utf-8'
opt.splitbelow = true
opt.splitright = true
