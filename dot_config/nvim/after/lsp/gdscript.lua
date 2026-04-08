-- Godot の組み込み LSP サーバーに接続する
-- Godot エディタを起動した状態で使用する
return {
  cmd = vim.lsp.rpc.connect('127.0.0.1', 6005),
  root_markers = { 'project.godot' },
  filetypes = { 'gdscript' },
}
