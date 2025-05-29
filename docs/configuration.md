# 設定の詳細

## ディレクトリ構成

```
dotfiles/
├── README.md              # 基本情報
├── Makefile               # タスク管理
├── LICENSE                # MIT License
├── .chezmoi.yaml          # chezmoi設定
├── .chezmoiexternal.toml  # 外部依存関係
├── .chezmoiignore         # 管理除外ファイル
├── docs/                  # ドキュメント
├── scripts/               # セットアップ・更新スクリプト
├── dot_config/
│   ├── nvim/              # Neovim設定（Lua + lazy.nvim）
│   ├── alacritty.toml     # Alacrittyターミナル設定
│   ├── starship.toml      # Starshipプロンプト設定
│   ├── lazygit/           # LazyGit設定
│   ├── fish/              # Fish shell設定
│   └── mise/              # miseランタイム管理設定
├── dot_zshrc.tmpl         # Zsh設定テンプレート
├── dot_mise.toml          # miseツール設定
└── private_dot_env.tmpl.age # 暗号化環境変数（age）
```

## 含まれる設定

### シェル・ターミナル

- **Zsh** シェル設定
- **Fish** 追加シェル
- **Starship** プロンプト（Git統合）
- **Alacritty** ターミナルエミュレーター

### 開発ツール

- **Neovim** Lua設定 + 多数のプラグイン
- **Git** エイリアス、ワークフロー拡張
- **LazyGit** Git操作のTUI
- **mise** ランタイムバージョン管理（Node.js、Go、Python等）

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

## ランタイム管理（mise）

### インストール済みツール

```bash
# 現在のバージョン確認
mise current

# 利用可能なツール確認
mise list
```

### よく使うランタイム

```bash
# Node.js
mise install node@latest
mise use node@18.17.0

# Python
mise install python@3.11
mise use python@3.11

# Go
mise install go@latest
mise use go@1.21
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