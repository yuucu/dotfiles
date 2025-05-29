local M = {}

-- Default life repository path
M.life_repo_path = vim.fn.expand('$HOME/ghq/github.com.yuucu/yuucu/life')

-- Change directory to life repository and open file finder
function M.search_documents()
  -- Change to life repository directory
  vim.cmd('cd ' .. M.life_repo_path)
  
  -- Open Telescope file finder
  vim.cmd('Telescope find_files')
end

-- Change directory to life repository only
function M.goto_documents()
  vim.cmd('cd ' .. M.life_repo_path)
  print('Changed directory to: ' .. M.life_repo_path)
end

-- Search in life repository without changing current directory
function M.search_documents_in_place()
  vim.cmd('Telescope find_files cwd=' .. M.life_repo_path)
end

-- Set custom life repository path
function M.set_life_repo_path(path)
  M.life_repo_path = vim.fn.expand(path)
end

-- Get current life repository path
function M.get_life_repo_path()
  return M.life_repo_path
end

return M 