-- Notes utility functions
local M = {}

-- Configuration
local NOTES_DIR = '/Users/s09104/ghq/github.com.yuucu/yuucu/life/notes/'
local DAILY_DIR = '/Users/s09104/ghq/github.com.yuucu/yuucu/life/docs/journal/'
local LIFE_REPO_ROOT = '/Users/s09104/ghq/github.com.yuucu/yuucu/life'

-- Helper function to get git repository root
local function get_git_root(path)
  local result = vim.fn.system('git -C ' .. vim.fn.shellescape(path) .. ' rev-parse --show-toplevel 2>/dev/null')
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return result:gsub('\n', '')
end

-- Function to create a new note with date prefix
function M.create_new_note()
  -- Get current date in YYYYMMDD format
  local date = os.date('%Y%m%d')

  -- Prompt for title
  local title = vim.fn.input('Note title: ')
  if title == '' then
    title = 'untitled'
  end

  -- Replace spaces with underscores and remove only problematic file system characters
  -- Keep Japanese characters and other Unicode characters
  title = title:gsub(' ', '_'):gsub('[/\\:*?"<>|]', '') -- Remove only file system problematic characters

  -- Create filename
  local filename = date .. '_' .. title .. '.md'
  local filepath = NOTES_DIR .. filename

  -- Create directory if it doesn't exist
  vim.fn.mkdir(NOTES_DIR, 'p')

  -- Open the file
  vim.cmd('edit ' .. vim.fn.fnameescape(filepath))

  -- Change to git repository root (use hardcoded path for reliability)
  vim.cmd('cd ' .. vim.fn.fnameescape(LIFE_REPO_ROOT))

  -- Add basic markdown header if file is new
  if vim.fn.getfsize(filepath) == 0 then
    local header = {
      '# ' .. title:gsub('_', ' '),
      '',
      'Date: ' .. os.date('%Y-%m-%d %H:%M:%S'),
      '',
      '## Content',
      '',
    }
    vim.api.nvim_buf_set_lines(0, 0, 0, false, header)
    -- Position cursor after the header
    vim.api.nvim_win_set_cursor(0, { #header + 1, 0 })
  end
end

-- Function to create/open daily note
function M.create_daily_note()
  -- Get current date and year
  local date = os.date('%Y%m%d')
  local year = os.date('%Y')

  -- Create daily directory path
  local daily_dir = DAILY_DIR .. year .. '/Daily/'
  local filename = date .. '.md'
  local filepath = daily_dir .. filename

  -- Create directory if it doesn't exist
  vim.fn.mkdir(daily_dir, 'p')

  -- Open the file
  vim.cmd('edit ' .. vim.fn.fnameescape(filepath))

  -- Change to git repository root (use hardcoded path for reliability)
  vim.cmd('cd ' .. vim.fn.fnameescape(LIFE_REPO_ROOT))

  -- Add basic markdown header if file is new
  if vim.fn.getfsize(filepath) == 0 then
    local header = {
      '# Daily Note - ' .. os.date('%Y-%m-%d'),
      '',
      'Date: ' .. os.date('%Y-%m-%d %H:%M:%S'),
      '',
      '## Todo',
      '',
      '- [ ] ',
      '',
      '## Notes',
      '',
      '## Reflection',
      '',
    }
    vim.api.nvim_buf_set_lines(0, 0, 0, false, header)
    -- Position cursor after the first todo item
    vim.api.nvim_win_set_cursor(0, { 7, 6 })
  end
end

return M
