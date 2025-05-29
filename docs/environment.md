# 環境変数管理

機密情報と公開設定を安全に分離して管理します。

## オプション1: ~/.zshrc.local（推奨）

### セットアップ

```bash
./scripts/setup-env.sh
```

### 設定例

`~/.zshrc.local` に実際のトークンを記載：

```bash
# APIトークン
export TEST_PAT="ghp_your_real_token"
export NPM_AUTH_TOKEN="npm_your_real_token"

# その他の機密情報
export OPENAI_API_KEY="sk-your-key"
export AWS_ACCESS_KEY_ID="your-access-key"
```

このファイルは：
- 自動的にzshrcで読み込まれる
- gitで管理されない（.gitignoreに含まれる）
- ローカル環境でのみ使用される

## オプション2: 暗号化管理（chezmoiのage暗号化）

より高いセキュリティが必要な場合：

```bash
# 暗号化された環境ファイルを追加
chezmoi add --encrypt ~/.env

# 暗号化ファイルを編集
chezmoi edit ~/.env

# 復号化して確認
chezmoi cat ~/.env
```

## オプション3: プロジェクト固有の.env（direnv）

プロジェクトごとに異なる環境変数が必要な場合：

```bash
# プロジェクトディレクトリで.envを作成
cd your-project
cp ~/.env.template .env

# プロジェクト固有の値を編集
echo "export PROJECT_API_KEY=project-specific-key" >> .env
echo "export DATABASE_URL=postgres://localhost/project_db" >> .env

# direnvが自動的に変数をロード/アンロード
```

## セキュリティのベストプラクティス

### 基本原則

- `.env`、`.zshrc.local`、実際の機密情報を含むファイルは絶対にコミットしない
- 開発環境と本番環境で異なるトークンを使用
- APIトークンを定期的にローテーション
- パスワードマネージャーに機密情報を保存
- 環境固有の設定を使用

### トークンの管理

```bash
# 仕事用と個人用でGitアイデンティティを切り替え
work-git      # 仕事用設定に切り替え
personal-git  # 個人用設定に切り替え

# 現在の設定を確認
git config --global user.name
git config --global user.email
```

### 機密情報のテンプレート化

テンプレートファイル（`.env.template`）の例：

```bash
# API Keys (replace with actual values)
export GITHUB_TOKEN="ghp_replace_with_your_token"
export NPM_TOKEN="npm_replace_with_your_token"

# Database connections
alias local_db="mysql -h localhost -u user -p[PASSWORD]"
alias staging_db="mysql -h staging.host -u user -p[PASSWORD]"

# Cloud provider credentials
export AWS_ACCESS_KEY_ID="replace_with_your_key"
export AWS_SECRET_ACCESS_KEY="replace_with_your_secret"
``` 