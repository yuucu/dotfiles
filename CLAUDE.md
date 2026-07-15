# dotfiles

nix-darwin + home-manager で管理する dotfiles リポジトリ（flake.nix がエントリポイント）。

## 編集と反映

- `config/` 配下は home-manager が symlink するため、編集は即反映される（rebuild 不要）
- Nix モジュール（flake.nix / darwin/ / home/）を修正した後は `make switch`（= `sudo darwin-rebuild switch --flake .`）で反映する
- パッケージ追加は `darwin/homebrew.nix`（cask・GUI）または `home/default.nix` の home.packages（CLI）

## シークレット・会社情報の混入禁止（徹底）

- API キー・トークン・パスワードなどの認証情報、社内 URL・社名・プロジェクト名・社用メールアドレスなど業務に紐づく情報は、このリポジトリ（設定ファイル・ドキュメント・コミットメッセージ含む）に一切書かない
- work 固有の設定（git identity・社内 URL）は `local/`（git 管理外）か環境変数に置く
- コミット前に差分への混入がないか確認する

## 検証

- `make ci-check`：CI と同じチェック（flake check + build dry-run + 全履歴 gitleaks）。コミット前に必ず通す
- `make check`：flake 評価

## git hook（lefthook）

CI との重複を避けるため、hook は「速い・確実・環境非依存」なものだけを担当する。

- **pre-commit**：staged ファイルの lint（shellcheck / stylua）と gitleaks（staged のみ）
- **pre-push**：`nix flake check`（lint 群の最終確認）。重い build dry-run と全履歴 gitleaks は GitHub Actions に任せる
- build 込みの完全な検証をローカルで確認したいときは `make ci-check` を手動で実行する

## 参照ドキュメント

- セットアップ手順とコマンド一覧：[README.md](README.md)
- 設計判断・移行経緯：[docs/design.md](docs/design.md)
