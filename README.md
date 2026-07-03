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

## セットアップ（新しい Mac）

```bash
# 1. Xcode CLT と Homebrew（brew 管理のパッケージ用）
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Nix のインストール（Determinate Systems installer）
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm

# 3. clone
mkdir -p ~/ghq/github.com/yuucu
git clone https://github.com/yuucu/dotfiles ~/ghq/github.com/yuucu/dotfiles
cd ~/ghq/github.com/yuucu/dotfiles

# 4. flake.nix の username / darwinConfigurations 名をそのマシンに合わせて確認

# 5. 適用（初回。dotfiles の symlink と brew パッケージ一式が入る）
sudo nix run nix-darwin/master -- switch --flake .

# 6. 以降の適用
make switch
```

### 適用後の手作業（最小限）

1. **`local/` の作成**（git 管理外。ないと `~/.gitconfig` 等の symlink が空振りする）
   - `local/gitconfig` … 本体。identity と `[include] path = ~/.gitconfig.local` など
   - `local/gitconfig-personal` … 個人用 identity（`includeIf` で `~/ghq/github.com/yuucu/` 配下に適用）
   - `local/gitconfig.local` / `local/zshrc.local` … work 固有の URL 書き換えや関数
2. **age 鍵の復元** … パスワードマネージャーから `~/.config/age/keys.txt` へ（`secrets/env.age` の復号に必要）
3. シェルを開き直す … zinit・プラグインは初回起動時に自動インストールされる
4. `mise install` / `gh auth login` などツール個別のログイン

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
