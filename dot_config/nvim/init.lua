--    _      _ __    __
--   (_)__  (_) /_  / /_ _____ _
--  / / _ \/ / __/ / / // / _ `/
-- /_/_//_/_/\__(_)_/\_,_/\_,_/
--

-- 共通のキーマップを読み込み
require('core.keymaps')

if vim.g.vscode then
  require('core.vscode')
else
  require('core.autocmd')
  require('core.lazyvim')
  require('core.options')
end
