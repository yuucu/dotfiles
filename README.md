# dotfiles

nix-darwin + home-manager による個人開発環境設定です。

![nvim](https://github.com/yuucu/dotfiles/assets/39527561/896889e6-fc51-4058-bdf2-4e917883e635)

## 構成

- **flake.nix** — エントリポイント（nixpkgs / nix-darwin / home-manager）
- **darwin/** — macOS システム設定と Homebrew（taps / brews / casks）の宣言的管理
- **home/** — home-manager。`config/` 配下の設定ファイルを symlink（`mkOutOfStoreSymlink`）
- **config/** — nvim / tmux / zsh / starship 等の実体。**編集は即反映（rebuild 不要）**
- **local/** — git 管理外。work の git identity・社内 URL 等のマシンローカル設定
- **secrets/** — age 暗号化された秘密情報

設計の詳細と移行計画は [docs/design.md](docs/design.md) を参照。

## セットアップ

```bash
# 1. Nix のインストール（Determinate Systems installer）
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# 2. clone
git clone https://github.com/yuucu/dotfiles ~/ghq/github.com/yuucu/dotfiles
cd ~/ghq/github.com/yuucu/dotfiles

# 3. 適用（初回）
sudo nix run nix-darwin/master -- switch --flake .

# 4. 以降の適用
make switch
```

手作業が必要なもの：age 鍵の復元（`~/.config/age/keys.txt`）、`local/` 配下の作成。

## よく使うコマンド

| コマンド | 説明 |
|---------|------|
| `make switch` | flake の変更をシステムに適用 |
| `make check` | 適用せずに評価チェック |
| `make update` | flake inputs・Neovim プラグイン・mise の更新 |
| `make ci-check` | CI と同じ lint チェック |
| `make status` | 環境の状態確認 |

`config/` 配下（nvim 設定など）の編集は symlink 経由で即反映されるため、`make switch` は不要です。ファイルの追加・削除・link 先の変更をしたときだけ `make switch` を実行します。

## ライセンス

MIT License
