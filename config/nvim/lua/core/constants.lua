-- Common constants for obsidian and notes configuration
local M = {}

-- Base paths
M.HOME_DIR = os.getenv('HOME')
M.LIFE_REPO_ROOT = M.HOME_DIR .. '/ghq/github.com.yuucu/yuucu/life'

-- Directory paths
M.NOTES_DIR = M.LIFE_REPO_ROOT .. '/docs/50_Notes/'
M.TIMELINE_BASE_DIR = M.LIFE_REPO_ROOT .. '/docs/20_Timeline/'
M.TEMPLATES_DIR = M.LIFE_REPO_ROOT .. '/Templates'

-- Daily notes configuration（年は起動時に動的解決）
M.DAILY_NOTES = {
  -- Relative path from life repo root for obsidian
  RELATIVE_FOLDER = 'docs/20_Timeline/' .. os.date('%Y') .. '/daily',
  -- Full path for other plugins
  FULL_PATH = M.TIMELINE_BASE_DIR .. os.date('%Y') .. '/daily/',
  DATE_FORMAT = '%Y%m%d',
}

-- Notes configuration
M.NOTES = {
  SUBDIR = 'docs/50_Notes',
  DATE_FORMAT = '%Y%m%d',
}

-- Get daily notes path for a specific year
function M.get_daily_path(year)
  return M.TIMELINE_BASE_DIR .. year .. '/daily/'
end

-- Get daily notes relative path for a specific year (for obsidian)
function M.get_daily_relative_path(year)
  return 'docs/20_Timeline/' .. year .. '/daily'
end

return M
