# dotfiles

chezmoi を使った個人開発環境設定です。

## クイックスタート

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yuucu/dotfiles
```

## 主な機能

- Neovim中心の開発環境
- 機密情報の安全な管理
- ワンライナーでのセットアップ
- macOS/Linux対応

## 基本的な使い方

```bash
# 設定の更新
chezmoi update

# Neovimプラグインの更新
nvim --headless "+Lazy! sync" +qa
```

## ドキュメント

詳細な情報は [docs](./docs/) フォルダを参照してください：

- [セットアップガイド](./docs/setup.md)
- [環境変数管理](./docs/environment.md)
- [設定の詳細](./docs/configuration.md)
- [使用方法](./docs/usage.md)

## ライセンス

MIT License
