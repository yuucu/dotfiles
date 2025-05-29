# 使用方法

## 日常的な操作

### ナビゲーション

```bash
# ディレクトリ移動
z <partial>  # よく使うディレクトリにジャンプ
..           # cd ..
...          # cd ../..

# Gitリポジトリ移動
fgh          # リポジトリを検索して移動
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
work-git     # 仕事用Gitアイデンティティに切り替え
personal-git # 個人用Gitアイデンティティに切り替え
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

### バッファ・ウィンドウ管理

```vim
# バッファ操作
:bn             # 次のバッファ
:bp             # 前のバッファ
:bd             # バッファを閉じる

# ウィンドウ操作
<C-h/j/k/l>     # ウィンドウ移動
<Space>sv       # 垂直分割
<Space>sh       # 水平分割
<C-w>q          # ウィンドウを閉じる
```

## tmux使用法

### セッション管理

```bash
# セッション操作
tmux new -s session_name    # 新しいセッション作成
tmux attach -t session_name # セッションにアタッチ
tmux list-sessions          # セッション一覧

# セッション内操作（Ctrl-a がプレフィックス）
<prefix>d                   # セッションからデタッチ
<prefix>s                   # セッション一覧
```

### ウィンドウ・ペイン管理

```bash
# ウィンドウ操作
<prefix>c       # 新しいウィンドウ
<prefix>n       # 次のウィンドウ
<prefix>p       # 前のウィンドウ
<prefix>&       # ウィンドウを閉じる

# ペイン操作
<prefix>%       # 垂直分割
<prefix>"       # 水平分割
<prefix>x       # ペインを閉じる
<prefix>o       # 次のペインへ移動
```

## パッケージ管理

### システムパッケージ

```bash
# Homebrewの使用（macOS）
brew install package_name
brew update
brew upgrade

# aptの使用（Linux）
sudo apt update
sudo apt install package_name
```

### ランタイム管理（mise）

```bash
# Node.js
mise install node@latest
mise use node@18.17.0

# Python
mise install python@3.11
mise use python@3.11

# Ruby
mise install ruby@3.2.0
mise use ruby@3.2.0

# 現在のバージョン確認
mise current
```

## 更新・メンテナンス

### dotfilesの更新

```bash
# 設定を最新に更新
chezmoi update

# 変更確認後に適用
chezmoi diff
chezmoi apply
```

### プラグインの更新

```bash
# Neovimプラグイン
nvim --headless "+Lazy! sync" +qa

# Zshプラグイン
zinit update --all

# システムパッケージ
brew upgrade        # macOS
sudo apt upgrade    # Linux
```

### 環境の確認

```bash
# システム情報
neofetch

# 設定の確認
chezmoi status
chezmoi diff

# Gitの設定確認
git config --global --list
```

## トラブルシューティング

### よくある問題

```bash
# Neovimプラグインエラー
nvim --headless "+Lazy! clean" +qa
nvim --headless "+Lazy! sync" +qa

# Zshプラグインエラー
zinit delete --all
zinit load

# 設定の競合
chezmoi apply --force

# 権限エラー
chmod +x scripts/*.sh
```

### ログの確認

```bash
# chezmoiのログ
chezmoi --verbose apply

# Neovimのログ
tail -f ~/.local/share/nvim/log/nvim.log

# システムログ
journalctl --user -f  # systemd
tail -f /var/log/system.log  # macOS
``` 