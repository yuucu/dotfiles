# dotfiles

chezmoi を使った個人開発環境設定です。

![nvim](https://github.com/yuucu/dotfiles/assets/39527561/896889e6-fc51-4058-bdf2-4e917883e635)
![nvim](https://github.com/yuucu/dotfiles/assets/39527561/d7b0b199-045d-4874-9147-4126cfea976e)

## クイックスタート

```bash
# 基本セットアップ（chezmoi + dotfiles）
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yuucu/dotfiles

# 必要なツールの確認・追加インストール
cd ~/.local/share/chezmoi && make install && make update
```

## 主な機能

- Neovim中心の開発環境
- 機密情報の安全な管理
- ワンライナーでのセットアップ
- macOS/Linux対応
- **mise**によるランタイム管理（Node.js、Go、Python等）

## 基本的な使い方

```bash
# 全体の更新（dotfiles + Neovimプラグイン + miseツール）
cd ~/.local/share/chezmoi && make update
```

## 開発・CI

このプロジェクトでは、ローカル開発とCI環境で**同じスクリプト**を使用してテストを実行しています。

```bash
# ローカルでCIと同じチェックを実行
make ci-check

# 手動でスクリプトを実行
./scripts/ci-check.sh
```

**チェック項目:**
- Shell script linting (shellcheck)
- Chezmoi template validation
- Lua formatting check (stylua)
- Neovim configuration test (CI環境のみ)
- Template processing test (CI環境のみ)
- File structure check
- Script executable check

## よく使うコマンド

| コマンド | 説明 |
|---------|------|
| `make help` | 利用可能なコマンド一覧を表示 |
| `make install` | 必要なツール（chezmoi、age、neovim、mise等）とランタイムをインストール |
| `make update` | dotfiles、Neovimプラグイン、miseツールを更新 |
| `make ci-check` | CIでチェックされる項目をローカルで確認 |
| `make status` | 環境の状態確認 |
| `make clean` | 一時ファイルのクリーンアップ |

## ドキュメント

詳細な情報は [docs](./docs/) フォルダを参照してください：

- [セットアップガイド](./docs/setup.md)
- [環境変数管理](./docs/environment.md)
- [設定の詳細](./docs/configuration.md)
- [使用方法](./docs/usage.md)

## ライセンス

MIT License
