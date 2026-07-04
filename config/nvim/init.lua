--    _      _ __    __
--   (_)__  (_) /_  / /_ _____ _
--  / / _ \/ / __/ / / // / _ `/
-- /_/_//_/_/\__(_)_/\_,_/\_,_/
--

-- 共通のキーマップ・ユーザーコマンドを読み込み
require('core.keymaps')
require('core.commands')

if vim.g.vscode then
  require('core.vscode')
else
  require('core.options')
  require('core.autocmd')
  require('core.lazy')
end
