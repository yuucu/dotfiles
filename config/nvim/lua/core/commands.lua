-- [[ User Commands ]]
-- utils モジュールは呼び出し時に require する（起動時の失敗でコマンド定義自体が消えないように）

local function call(module, fn_name)
  return function()
    local ok, mod = pcall(require, module)
    if not ok then
      vim.notify('Failed to load ' .. module .. ': ' .. tostring(mod), vim.log.levels.ERROR)
      return
    end
    mod[fn_name]()
  end
end

vim.api.nvim_create_user_command(
  'Today',
  call('utils.notes', 'create_daily_note'),
  { desc = "Create or open today's daily note" }
)

vim.api.nvim_create_user_command('NewNote', call('utils.notes', 'create_new_note'), { desc = 'Create a new note' })

vim.api.nvim_create_user_command(
  'Documents',
  call('utils.documents', 'search_documents'),
  { desc = 'Search documents in life repository' }
)
