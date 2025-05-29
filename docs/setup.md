# セットアップガイド

## 依存関係

以下のツールが必要です：

- chezmoi >= 2.50
- age（暗号化ツール）
- git
- neovim >= 0.10
- fzf
- starship

依存関係はbootstrapスクリプトで自動インストールされます。

## 基本インストール

### ワンライナーインストール

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yuucu/dotfiles
```

### 手動インストール

```bash
# chezmoiをインストール
curl -sfL https://git.io/chezmoi | sh

# dotfilesをクローン・適用
chezmoi init yuucu/dotfiles
chezmoi apply
```

## 初期設定

### 1. 環境変数の設定

セットアップスクリプトを実行：
```bash
./scripts/setup-env.sh
```

### 2. Git設定

初回セットアップ後、Git設定を確認：
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## トラブルシューティング

### 権限エラー

```bash
# スクリプト実行権限を付与
chmod +x scripts/*.sh
```

### Neovimプラグインエラー

```bash
# プラグインを再インストール
nvim --headless "+Lazy! clean" +qa
nvim --headless "+Lazy! sync" +qa
```

### 設定の競合

```bash
# 既存設定をバックアップ
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.zshrc ~/.zshrc.backup

# 再適用
chezmoi apply --force
``` 