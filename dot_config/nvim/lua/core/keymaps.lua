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

-- Load utility modules for custom commands with error handling
local notes_ok, notes = pcall(require, 'utils.notes')
local documents_ok, documents = pcall(require, 'utils.documents')

if not notes_ok then
  vim.notify('Failed to load utils.notes: ' .. tostring(notes), vim.log.levels.ERROR)
end

if not documents_ok then
  vim.notify('Failed to load utils.documents: ' .. tostring(documents), vim.log.levels.ERROR)
end

-- Create user commands for quick access
if notes_ok then
  vim.api.nvim_create_user_command('Today', function()
    notes.create_daily_note()
  end, { desc = 'Create or open today\'s daily note' })

  vim.api.nvim_create_user_command('NewNote', function()
    notes.create_new_note()
  end, { desc = 'Create a new note' })
else
  vim.api.nvim_create_user_command('Today', function()
    vim.notify('utils.notes module not available', vim.log.levels.ERROR)
  end, { desc = 'Create or open today\'s daily note (DISABLED)' })

  vim.api.nvim_create_user_command('NewNote', function()
    vim.notify('utils.notes module not available', vim.log.levels.ERROR)
  end, { desc = 'Create a new note (DISABLED)' })
end

if documents_ok then
  vim.api.nvim_create_user_command('Documents', function()
    documents.search_documents()
  end, { desc = 'Search documents in life repository' })
else
  vim.api.nvim_create_user_command('Documents', function()
    vim.notify('utils.documents module not available', vim.log.levels.ERROR)
  end, { desc = 'Search documents in life repository (DISABLED)' })
end
