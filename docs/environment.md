# 環境変数管理

機密情報と公開設定を安全に分離して管理します。

## オプション1: 暗号化管理（推奨）

chezmoiのage暗号化を使用した安全な管理：

```bash
# 暗号化された環境ファイルを編集
chezmoi edit ~/.env

# 復号化して確認
chezmoi cat ~/.env
```

### 初期設定

```bash
# age鍵を生成（初回のみ）
age-keygen -o ~/.config/chezmoi/key.txt

# .chezmoi.yamlに公開鍵を設定
```

## オプション2: ローカルファイル

```bash
# ローカル環境変数ファイルを作成
touch ~/.zshrc.local

# 実際のトークンを記載
echo 'export GITHUB_TOKEN="your_real_token"' >> ~/.zshrc.local
echo 'export OPENAI_API_KEY="your_real_key"' >> ~/.zshrc.local
```

このファイルは：
- 自動的にzshrcで読み込まれる
- gitで管理されない（.gitignoreに含まれる）
- ローカル環境でのみ使用される

## セキュリティのベストプラクティス

### 基本原則

- `.env`、`.zshrc.local`等の機密情報を含むファイルは絶対にコミットしない
- 開発環境と本番環境で異なるトークンを使用
- APIトークンを定期的にローテーション
- パスワードマネージャーに機密情報を保存

### 機密情報のテンプレート化

テンプレートファイル（`private_dot_env.tmpl.age`）の例：

```bash
# API Keys (暗号化されたテンプレート)
export GITHUB_TOKEN="{{ .github_token }}"
export OPENAI_API_KEY="{{ .openai_api_key }}"

# Database connections
export DATABASE_URL="{{ .database_url }}"
``` 