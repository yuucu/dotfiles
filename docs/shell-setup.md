# Shell 環境セットアップガイド

このガイドでは、zsh と modern CLI tools を使った快適なシェル環境を構築します。

## 必要なツールのインストール

### 1. Modern CLI Tools

```bash
# すべて一括インストール
brew install fd bat eza zoxide fzf ripgrep

# 個別インストール
brew install fd        # 高速なファイル検索
brew install bat       # 構文ハイライト付き cat
brew install eza       # モダンな ls
brew install zoxide    # スマートな cd
brew install fzf       # ファジーファインダー
brew install ripgrep   # 高速な grep
```

### 2. 追加の便利ツール

```bash
brew install ghq       # Git リポジトリ管理
brew install lazygit   # Git TUI
brew install jq        # JSON プロセッサ
brew install mise      # ランタイムバージョン管理
brew install starship  # プロンプトテーマ
```

## ファイル構成

```
~/.zshrc          # メイン設定ファイル
~/.zshenv         # 環境変数
~/.zsh_aliases    # エイリアス定義
~/.zsh_functions  # 関数定義
~/.zshrc.local    # ローカル固有設定（オプション）
```

## 主要機能

### Modern CLI Tools の置き換え

| 従来のコマンド | 置き換え | 説明 |
|--------------|---------|------|
| `ls` | `eza` | アイコン・Git ステータス表示 |
| `cat` | `bat` | シンタックスハイライト |
| `find` | `fd` | 高速・直感的 |
| `grep` | `rg` (ripgrep) | 超高速検索 |
| `cd` | `z` (zoxide) | 頻度ベースのディレクトリジャンプ |

### fzf 統合

**キーバインド:**
- `CTRL-T`: ファイル検索（プレビュー付き）
- `CTRL-R`: コマンド履歴検索
- `ALT-C`: ディレクトリ検索

**設定済み:**
- `fd` でファイル検索
- `bat` でプレビュー表示
- `eza` でディレクトリプレビュー

## Git Aliases

### 基本操作

```bash
g         # git
gs        # git status -sb (短縮表示)
ga        # git add
gaa       # git add --all
gc        # git commit -v
gcm       # git commit -m
```

### ブランチ操作

```bash
gb        # git branch
gba       # git branch -a (全ブランチ)
gbd       # git branch -d (削除)
gco       # git checkout
gcb       # git checkout -b (新規作成)
```

### 差分・ログ

```bash
gd        # git diff
gds       # git diff --staged
glog      # git log --oneline --graph
gloga     # git log --all --graph
```

### リモート操作

```bash
gf        # git fetch
gl        # git pull
gp        # git push
gpf       # git push --force-with-lease
gpu       # git push -u origin <current-branch>
```

### その他

```bash
gr        # git restore
grs       # git restore --staged
gst       # git stash
gstp      # git stash pop
```

## Useful Functions

### ファジー検索

```bash
fgh       # ghq リポジトリを fzf で選択して移動
gcof      # Git ブランチを fzf で選択してチェックアウト
gshowf    # Git コミットを fzf で選択して詳細表示
gdf       # Git 変更ファイルを fzf で選択して差分表示
vf        # ファイルを fzf で検索して nvim で開く
vfg       # Git 管理ファイルを fzf で検索して nvim で開く
fkill     # プロセスを fzf で選択して kill
fh        # コマンド履歴を fzf で検索
```

### ディレクトリ操作

```bash
mkcd <dir>        # ディレクトリ作成 & 移動
tmpcd             # 一時ディレクトリ作成 & 移動
cdroot            # Git ルートディレクトリに移動
tree [level]      # ディレクトリツリー表示
```

### Git 便利関数

```bash
git_main_branch   # デフォルトブランチ名を取得
gbdel <branch>    # ブランチ削除（local + remote）
gcnb <branch>     # 新規ブランチ作成 & push
```

### 開発関連

```bash
npmscripts        # package.json の scripts を表示
killport <port>   # ポートを使用しているプロセスを kill
dexec             # Docker コンテナを fzf で選択して exec
```

### ユーティリティ

```bash
extract <file>         # アーカイブを展開（自動判別）
compress <file>        # tar.gz で圧縮
jsonformat [file]      # JSON を整形表示
urlencode <string>     # URL エンコード
urldecode <string>     # URL デコード
myip                   # IP アドレス表示
```

## Navigation Aliases

```bash
..        # cd ..
...       # cd ../..
....      # cd ../../..

# zoxide を使う場合
z <dir>   # 頻度ベースでディレクトリ移動
zi        # インタラクティブ選択
```

## Editor Aliases

```bash
v         # nvim
vi        # nvim
vim       # nvim
vdiff     # nvim -d (差分表示)
```

## Development Aliases

### Node.js / npm

```bash
ni        # npm install
nid       # npm install --save-dev
nr        # npm run
nrs       # npm run start
nrd       # npm run dev
nrb       # npm run build
nrt       # npm run test
```

### Bun

```bash
bi        # bun install
br        # bun run
bt        # bun test
```

### Docker

```bash
d         # docker
dc        # docker compose
dcu       # docker compose up
dcd       # docker compose down
dps       # docker ps
```

### Kubernetes

```bash
k         # kubectl
kgp       # kubectl get pods
kgs       # kubectl get services
kl        # kubectl logs
```

## カスタマイズ

### ローカル設定の追加

マシン固有の設定は `~/.zshrc.local` に記述します：

```bash
# ~/.zshrc.local の例
export CUSTOM_VAR="value"
alias myalias="command"

# 会社固有の設定
export WORK_DIR="/path/to/work"
alias work="cd $WORK_DIR"
```

### FZF のカスタマイズ

`~/.zshrc` の `FZF_DEFAULT_OPTS` を編集：

```bash
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc
'
```

### プロンプトのカスタマイズ

Starship を使用している場合、`~/.config/starship.toml` を編集：

```toml
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"

[directory]
truncation_length = 3
truncate_to_repo = true
```

## 使用例

### プロジェクトへの移動

```bash
# 頻繁に使うディレクトリに移動
z myproject

# fzf でリポジトリを検索して移動
fgh
```

### ブランチ切り替え

```bash
# fzf でブランチ選択
gcof

# 新しいブランチを作成してプッシュ
gcnb feature/new-feature
```

### ファイル編集

```bash
# fzf でファイルを検索して編集
vf

# Git 管理ファイルから検索
vfg
```

### Git 操作

```bash
# 変更をコミット
ga .
gcm "feat: add new feature"

# プッシュ
gpu
```

### Docker 操作

```bash
# コンテナを起動
dcu -d

# コンテナに入る
dexec  # fzf で選択
```

## トラブルシューティング

### zsh 設定がリロードされない

```bash
# 設定をリロード
source ~/.zshrc

# または
reload
```

### コマンドが見つからない

```bash
# パスを確認
echo $PATH

# コマンドの場所を確認
which <command>

# Homebrew のパスを確認
brew --prefix
```

### fzf が動作しない

```bash
# fzf がインストールされているか確認
which fzf

# fzf を再インストール
brew reinstall fzf
```

### プラグインが読み込まれない

```bash
# zinit を再インストール
rm -rf ~/.local/share/zinit
source ~/.zshrc
```

## パフォーマンス最適化

### 起動時間の計測

```bash
# zsh の起動時間を計測
time zsh -i -c exit

# プロファイリング
zsh -xv 2>&1 | ts -i "%.s" | tee /tmp/zsh-profile
```

### 遅いプラグインを特定

```bash
# zinit のロード時間を表示
zinit times
```

## 参考リンク

- [fd](https://github.com/sharkdp/fd)
- [bat](https://github.com/sharkdp/bat)
- [eza](https://github.com/eza-community/eza)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [fzf](https://github.com/junegunn/fzf)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [starship](https://starship.rs/)
- [mise](https://mise.jdx.dev/)
