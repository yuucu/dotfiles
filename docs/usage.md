# 使用方法

## 日常的な操作

### ナビゲーション

```bash
# ディレクトリ移動
z <partial>  # よく使うディレクトリにジャンプ
..           # cd ..
...          # cd ../..
```

### Git操作

```bash
# 基本操作
g            # git
gs           # git status
ga           # git add
gc           # git commit
gp           # git push

# 高度な操作
lg           # LazyGit TUI
```

### ファイル操作

```bash
# ファイル表示・編集
v filename   # Neovimで開く
bat filename # シンタックスハイライト付きで表示
eza -la      # 詳細なファイル一覧

# 検索
rg "pattern" # ripgrepで高速検索
fd filename  # ファイル名検索
```

## Neovim使用法

### 基本操作

```vim
# ファイル操作
:e filename      # ファイルを開く
:w              # 保存
:q              # 終了
:wq             # 保存して終了

# 検索・置換
/pattern        # 前方検索
?pattern        # 後方検索
:%s/old/new/g   # 全体置換
```

### プラグイン操作

```vim
# Telescope（ファジーファインダー）
<Space>ff       # ファイル検索
<Space>fg       # テキスト検索（grep）
<Space>fb       # バッファ検索
<Space>fh       # ヘルプ検索

# ファイルツリー
<Space>e        # nvim-tree toggle

# Git操作
<Space>gs       # Git status
<Space>gb       # Git blame
<Space>gd       # Git diff

# LSP機能
gd              # 定義にジャンプ
gr              # 参照を表示
K               # ホバー情報
<Space>ca       # コードアクション
```

## ランタイム管理（mise）

### バージョン管理

```bash
# 現在のバージョン確認
mise current

# 利用可能なバージョン一覧
mise list nodejs
mise list python

# インストール
mise install nodejs@18.17.0
mise install python@3.11

# プロジェクト固有のバージョン設定
mise use nodejs@18.17.0
mise use python@3.11
```

## 更新・メンテナンス

### dotfilesの更新

```bash
# dotfilesディレクトリに移動
cd $(chezmoi source-path)

# 全体の更新（dotfiles + Neovimプラグイン + miseツール）
make update

# 状態確認
make status
```

### 個別の更新

```bash
# Neovimプラグイン
nvim --headless "+Lazy! sync" +qa

# miseツール
mise upgrade

# 設定の適用
chezmoi apply
```

## トラブルシューティング

### よくある問題

```bash
# Neovimプラグインエラー
nvim --headless "+Lazy! clean" +qa
nvim --headless "+Lazy! sync" +qa

# 設定の競合
chezmoi diff
chezmoi apply --force

# 権限エラー
chmod +x scripts/*.sh
```

### ログの確認

```bash
# chezmoiのログ
chezmoi --verbose apply

# miseのログ
mise doctor

# Neovimのログ
tail -f ~/.local/share/nvim/log/nvim.log
``` 