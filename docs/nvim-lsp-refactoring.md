# Neovim LSP設定簡潔化リファクタリング

## 概要

dotfilesのNeovim LSP設定を簡潔化し、記述量を大幅に削減するリファクタリングを実施しました。
機能は全て保持したまま、保守性と可読性を向上させています。

## 修正対象ファイル

### 1. `nvim-lspconfig.lua`
- **修正前**: 121行
- **修正後**: 66行
- **削減率**: 約45%

### 2. `lspsaga.lua`
- **修正前**: 89行
- **修正後**: 35行
- **削減率**: 約60%

### 3. `nvim-cmp.lua`
- **修正前**: 51行
- **修正後**: 41行
- **削減率**: 約20%

## 主な修正内容

### nvim-lspconfig.lua の改善

#### Before (冗長な記述)
```lua
-- TypeScript
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  single_file_support = false,
  root_dir = lspconfig.util.root_pattern('package.json'),
})

-- Deno
lspconfig.denols.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern('deno.json'),
  init_options = { ... }
})

-- 個別にキーマップ設定
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
-- ...
```

#### After (テーブル駆動設定)
```lua
-- LSPサーバー設定
local servers = {
  ts_ls = { single_file_support = false, root_dir = lspconfig.util.root_pattern('package.json') },
  denols = { 
    root_dir = lspconfig.util.root_pattern('deno.json'),
    init_options = { lint = true, unstable = true }
  },
  lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
  gopls = {},
}

for server, config in pairs(servers) do
  config.capabilities = capabilities
  config.on_attach = on_attach
  lspconfig[server].setup(config)
end

-- キーマップテーブル
local maps = {
  gD = vim.lsp.buf.declaration,
  gd = vim.lsp.buf.definition,
  -- ...
}
for key, func in pairs(maps) do
  vim.keymap.set('n', key, func, opts)
end
```

### lspsaga.lua の改善

#### Before (個別設定)
```lua
local keymap = vim.keymap.set
keymap('n', 'gh', '<cmd>Lspsaga finder<CR>')
keymap({ 'n', 'v' }, 'ga', '<cmd>Lspsaga code_action<CR>')
keymap('n', 'gp', '<cmd>Lspsaga peek_definition<CR>')
-- 各キーマップを個別に設定...
```

#### After (テーブル駆動)
```lua
local maps = {
  gh = 'Lspsaga finder',
  ga = 'Lspsaga code_action',
  gp = 'Lspsaga peek_definition',
  -- ...
}

for key, cmd in pairs(maps) do
  local mode = key == 'ga' and { 'n', 'v' } or 'n'
  vim.keymap.set(mode, key, '<cmd>' .. cmd .. '<CR>')
end
```

### nvim-cmp.lua の改善

#### Before
```lua
dependencies = {
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'saadparwaiz1/cmp_luasnip' },
  -- ...
}
```

#### After
```lua
dependencies = {
  'hrsh7th/cmp-nvim-lsp',
  'saadparwaiz1/cmp_luasnip',
  -- ...
}
```

## 簡潔化テクニック

### 1. テーブル駆動設定
繰り返しの設定処理をテーブルとループで実装
- LSPサーバー設定の統一化
- キーマップの一括設定

### 2. 記法の統一
- dependencies記法: `{ 'name' }` → `'name'`
- 設定オブジェクトのワンライナー化

### 3. 冗長なコメント削除
- 長いコメントブロックの整理
- 実装に必要な情報のみ保持

### 4. 共通処理の統合
- 共通のcapabilities, on_attachの一元化
- 診断設定の簡潔化

## 効果

### 記述量削減
- **総行数**: 261行 → 142行（約45%削減）
- **保守性向上**: 設定変更時の修正箇所が減少
- **可読性向上**: 重要な設定が見つけやすくなった

### 機能保持
- 全てのLSP機能は変更前と同じように動作
- キーバインドも全て保持
- 診断、補完、フォーマット機能も変更なし

## 追加の改善提案

### 1. 設定ファイルの分割
```
lua/lsp/
├── init.lua          # LSP全体の初期化
├── servers.lua       # サーバー設定
└── keymaps.lua       # キーマップ設定
```

### 2. 環境別設定
- プロジェクト固有の設定をテンプレート化
- 言語別の自動フォーマット設定拡張

### 3. エラーハンドリング強化
- LSPサーバーの存在チェック
- 設定読み込み失敗時の適切な処理

## まとめ

このリファクタリングにより、dotfilesの保守性が大幅に向上しました。
新しい言語サポートの追加や設定変更が簡単になり、
設定の見通しも良くなっています。

機能は一切削らずに記述量を半分近く削減できており、
今後の dotfiles メンテナンスが楽になります。