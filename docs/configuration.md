# 設定の詳細

## ディレクトリ構成

```
dotfiles/
├── README.md              # 基本情報
├── LICENSE                # MIT License
├── .chezmoi.yaml          # chezmoi設定
├── .chezmoiignore         # 管理除外ファイル
├── docs/                  # ドキュメント
├── scripts/
│   ├── bootstrap.sh       # 初期セットアップ
│   └── setup-env.sh       # 環境変数セットアップ
├── dot_config/
│   └── nvim/              # Neovim設定（Lua + lazy.nvim）
│       ├── init.lua
│       └── lua/
└── private/               # 暗号化ファイル（age）
```

## 含まれる設定

### シェル・ターミナル

- **Zsh** + Zinit プラグインマネージャー
- **Starship** プロンプト（Git統合）
- **Alacritty** ターミナルエミュレーター
- **tmux** ターミナルマルチプレクサー

### 開発ツール

- **Neovim** Lua設定 + 50以上のプラグイン
- **Git** エイリアス、ワークフロー拡張
- **LazyGit** Git操作のTUI
- **mise** ランタイムバージョン管理
- **direnv** 環境変数管理

### 生産性ツール

- **fzf** ファジー検索
- **eza** Git統合のls
- **bat** シンタックスハイライト付きcat
- **ripgrep** 高速grep
- **zoxide** スマートcd

## Neovim設定

### プラグイン管理

lazy.nvimを使用したプラグイン管理：

```lua
-- プラグインの自動インストール・更新
:Lazy sync

-- プラグイン状態の確認
:Lazy
```

### 主要プラグイン

- **LSP**: 言語サーバー統合
- **Treesitter**: シンタックスハイライト
- **Telescope**: ファジーファインダー
- **nvim-tree**: ファイルエクスプローラー
- **Gitsigns**: Git統合
- **Which-key**: キーバインド表示

### キーバインド

リーダーキー: `<Space>`

```vim
# ファイル操作
<Space>ff    # ファイル検索
<Space>fg    # テキスト検索
<Space>fb    # バッファ検索

# Git操作
<Space>gs    # Git status
<Space>gc    # Git commit
<Space>gp    # Git push

# ウィンドウ操作
<C-h/j/k/l>  # ウィンドウ移動
<Space>sv    # 垂直分割
<Space>sh    # 水平分割
```

## Zsh設定

### エイリアス

```bash
# ナビゲーション
..           # cd ..
...          # cd ../..
....         # cd ../../..

# Git
g            # git
gs           # git status
ga           # git add
gc           # git commit
gp           # git push

# ツール
lg           # lazygit
v            # nvim
```

### プラグイン（Zinit）

- **zsh-autosuggestions**: コマンド補完
- **zsh-syntax-highlighting**: シンタックスハイライト
- **fzf-tab**: タブ補完の改善
- **zoxide**: ディレクトリジャンプ

## Git設定

### グローバル設定

```bash
# エディタ設定
git config --global core.editor nvim

# デフォルトブランチ
git config --global init.defaultBranch main

# プッシュ設定
git config --global push.default simple
```

### エイリアス

```bash
# よく使うコマンドのエイリアス
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm commit
```

## tmux設定

### キーバインド

プレフィックスキー: `Ctrl-a`

```bash
# セッション管理
<prefix>s    # セッション一覧
<prefix>d    # セッションからデタッチ

# ウィンドウ管理
<prefix>c    # 新しいウィンドウ
<prefix>n    # 次のウィンドウ
<prefix>p    # 前のウィンドウ

# ペイン管理
<prefix>%    # 垂直分割
<prefix>"    # 水平分割
<prefix>x    # ペインを閉じる
```

## カスタマイズ

### 設定の追加

新しい設定を追加する場合：

```bash
# chezmoiで管理に追加
chezmoi add ~/.new-config

# 設定を編集
chezmoi edit ~/.new-config

# 変更を適用
chezmoi apply
```

### プラグインの追加

Neovimプラグインを追加：

```lua
-- lua/plugins/your-plugin.lua
return {
  "author/plugin-name",
  config = function()
    -- 設定
  end
}
```

Zshプラグインを追加：

```bash
# .zshrcに追加
zinit load "author/plugin-name"
``` 