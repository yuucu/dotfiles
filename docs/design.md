# dotfiles Design Doc

- Status: Approved（Nix 移行を決定）
- Date: 2026-07-03

## 1. 背景と目的

本リポジトリは chezmoi ベースの dotfiles として運用してきましたが、以下の課題がありました。

- リポジトリ管理用ファイルが `~/` に配布されていた（2026-07 修正済み）
- `.zshrc` と mise の `config.toml` が管理外で、新マシンで再現できない
- Homebrew パッケージ（formula 203 + cask 81）が宣言的に管理されていない
- age 暗号化した `.env` が命名ミスにより一度も適用されていなかった（命名は修正済み）
- macOS のシステム設定（defaults）が管理されていない

検討の結果、**nix-darwin + home-manager による Nix flake 構成へ移行**します。

## 2. 要件と決定事項

| 項目 | 決定 |
|---|---|
| スコープ | nix-darwin + home-manager（システム設定・Homebrew・dotfiles・CLI パッケージを flake で一元管理） |
| 既存設定ファイル | Nix モジュールに書き直さず、`mkOutOfStoreSymlink` で **そのまま link**。編集後の rebuild 不要、lazy.nvim 等の既存エコシステムを維持 |
| ランタイム | mise を継続（プロジェクトごとの切り替えは mise、Nix はグローバルツールと dotfiles に専念） |
| Homebrew | 廃止せず nix-darwin の `homebrew` モジュールで宣言的管理（cask・GUI アプリは brew が現実的）。formula は段階的に nixpkgs へ移行 |
| 秘密情報 | work の identity・社内情報は git 管理外ファイルに分離（現行方針を維持）。暗号化 `.env` は将来 agenix 化を検討 |

### chezmoi から移行する理由

chezmoi は dotfiles 配布としては十分だが、パッケージ（Homebrew）・システム設定・dotfiles が別々の仕組みに分散する。Nix flake に寄せることで「マシンの状態」を 1 リポジトリ・1 コマンド（`darwin-rebuild switch`）に集約し、ロールバックも世代管理で可能になる。

### link 方式（mkOutOfStoreSymlink）について

home-manager の標準は設定を Nix store に取り込む方式だが、nvim 設定（lua 数十ファイル）を都度 rebuild するのは開発体験が悪い。`config.lib.file.mkOutOfStoreSymlink` で repo 内のファイルを直接 symlink し、**編集は即反映・構成は Nix が管理**のハイブリッドとする。トレードオフとして repo の絶対パス（`~/ghq/github.com/yuucu/dotfiles`）に依存する。

## 3. 目標構成

```
dotfiles/
├── flake.nix                    # エントリポイント（nixpkgs / nix-darwin / home-manager）
├── flake.lock
├── darwin/
│   └── default.nix              # macOS システム設定・nix 設定・homebrew（taps/brews/casks）
├── home/
│   ├── default.nix              # home-manager 本体（packages、環境変数）
│   └── links.nix                # mkOutOfStoreSymlink による config/ の link 定義
├── config/                      # 実体の設定ファイル（旧 dot_config/。編集即反映）
│   ├── nvim/ tmux/ zsh/ starship.toml alacritty.toml ...
│   ├── mise/config.toml         # ★ 新規管理
│   └── zsh/                     # ★ 新規管理（~/.zshrc の分割）
├── local/                       # git 管理外（work の gitconfig・work.zsh 等）※ .gitignore 対象
├── docs/ scripts/ Makefile      # repo 運用ファイル
└── .github/workflows/ci.yml    # shellcheck / stylua / nix flake check
```

- chezmoi の `dot_` プレフィックス・`.tmpl` は廃止。テンプレートだった箇所（homeDir・OS 分岐）は lua の `os.getenv("HOME")` や Nix 側の条件分岐で置き換える
- work 固有の設定（git identity、社内 URL、work 用 zsh 関数）は `local/` に置き、home-manager が存在すれば link する。public repo には含めない

## 4. ブートストラップ

```bash
# 1. Nix インストール（Determinate Systems installer 推奨）
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# 2. clone & 適用
git clone https://github.com/yuucu/dotfiles ~/ghq/github.com/yuucu/dotfiles
cd ~/ghq/github.com/yuucu/dotfiles
sudo nix run nix-darwin -- switch --flake .#yuucu-mac   # 初回
darwin-rebuild switch --flake .                            # 以降

# 3. 手作業（最小限）
#    - age 鍵の復元（~/.config/age/keys.txt）
#    - local/ 配下の work 設定の配置
```

注意：Determinate installer は自前で Nix デーモンを管理するため、nix-darwin 側は `nix.enable = false` にする。

## 5. 移行計画

| Phase | 内容 | 状態 |
|---|---|---|
| 0 | chezmoi 構成の応急修正（配布事故・purge・drift・`.env` 命名） | ✅ 完了（2026-07-03） |
| 1 | 移行ブランチで flake スキャフォールド：flake.nix / darwin/ / home/、`dot_config` → `config` リネーム、テンプレート排除、`.zshrc`・mise config の取り込み、Homebrew 現状の宣言化 | 🔄 実施中 |
| 2 | Nix インストール → `darwin-rebuild switch` で適用・検証。chezmoi の symlink 化されない旧ファイルとの差分確認 | 🔲 |
| 3 | chezmoi 関連ファイル（`.chezmoi*`、Makefile の chezmoi タスク）の削除、README・CI 更新、main へマージ、`chezmoi purge` | 🔲 |
| 4 | formula の nixpkgs への段階移行（brew は cask 中心へ）、`.env` の agenix 化、Linux（home-manager 単体）対応 | 🔲 |

### ロールバック

Phase 2 で問題が出た場合、chezmoi 構成は main に残っているため `chezmoi apply` で即復帰できる。Nix 世代のロールバックは `darwin-rebuild --rollback`。
