# セットアップガイド

## クイックスタート

### ワンライナーインストール

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yuucu/dotfiles
```

### 完全セットアップ

```bash
# dotfilesディレクトリに移動
cd $(chezmoi source-path)

# 必要なツール・ランタイムをインストール
make install
```

## 利用可能なコマンド

| コマンド | 説明 |
|---------|------|
| `make help` | 利用可能なコマンド一覧を表示 |
| `make install` | 必要なツール（chezmoi、age、neovim、mise等）とランタイムをインストール |
| `make update` | dotfiles、Neovimプラグイン、miseツールを更新 |
| `make status` | 環境の状態確認 |
| `make clean` | 一時ファイルのクリーンアップ |

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
# 変更確認後に強制適用
chezmoi diff
chezmoi apply --force
``` 