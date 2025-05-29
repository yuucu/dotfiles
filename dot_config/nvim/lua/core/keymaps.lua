-- [[ Basic Keymaps ]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opts = { noremap = true }

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- for US keyboard
vim.keymap.set('n', ';', ':', opts)
vim.keymap.set('n', ':', ';', opts)

-- Load utility modules for custom commands
local notes = require('utils.notes')
local documents = require('utils.documents')

-- Create user commands for quick access
vim.api.nvim_create_user_command('Today', function()
  notes.create_daily_note()
end, { desc = 'Create or open today\'s daily note' })

vim.api.nvim_create_user_command('Documents', function()
  documents.search_documents()
end, { desc = 'Search documents in life repository' })

vim.api.nvim_create_user_command('NewNote', function()
  notes.create_new_note()
end, { desc = 'Create a new note' })
