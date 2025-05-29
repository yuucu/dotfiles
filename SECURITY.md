# セキュリティガイドライン

## 🛡️ 機密情報の管理

このdotfilesリポジトリでは、機密情報の漏洩を防ぐため以下の原則に従います。

### ❌ 含めてはいけない情報

- **クラウド認証情報**
  - `gcloud/application_default_credentials.json`
  - `gcloud/access_tokens.db`
  - `gcloud/credentials.db`
  - AWS credentials
  
- **API キー・トークン**
  - GitHub personal access tokens
  - Raycast API keys
  - OpenAI API keys
  - その他のサービスAPIキー

- **暗号化鍵**
  - `age/keys.txt` (age秘密鍵)
  - SSH秘密鍵 (暗号化されていない)

### ✅ 安全な管理方法

#### 1. age暗号化の使用

```bash
# 機密ファイルを暗号化して追加
chezmoi add --encrypt ~/.ssh/id_rsa
chezmoi add --encrypt ~/.config/gcloud/application_default_credentials.json

# 暗号化ファイルの編集
chezmoi edit --apply ~/.ssh/id_rsa
```

#### 2. 環境変数での管理

```bash
# .chezmoiroot.yaml でのテンプレート変数設定
data:
  github_token: "{{ env "GITHUB_TOKEN" }}"
  openai_api_key: "{{ env "OPENAI_API_KEY" }}"
```

#### 3. 外部キーマネージャーの使用

```bash
# 1Password CLI
export GITHUB_TOKEN="$(op item get "GitHub Token" --fields password)"

# macOS Keychain
export API_KEY="$(security find-generic-password -s myservice -w)"
```

### 🔍 セキュリティチェック

適用前に必ずチェックしてください：

```bash
# 機密情報の漏洩チェック
grep -r -i "secret\|token\|password\|key" dot_config/ | grep -v ".lua"

# age暗号化の確認
find . -name "*.age" -o -name "encrypted_*"

# 除外設定の確認
chezmoi ignored
```

### 🚨 事故時の対応

機密情報を誤ってコミットした場合：

1. **即座にリポジトリから削除**
```bash
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch path/to/secret/file' --prune-empty --tag-name-filter cat -- --all
```

2. **認証情報の無効化**
   - APIキーの再生成
   - トークンの削除
   - パスワードの変更

3. **GitHubでのforce push**
```bash
git push origin --force --all
```

### 📋 定期チェック

- 月1回：機密情報スキャン実行
- リリース前：セキュリティレビュー実施
- コミット前：`git diff --cached`で差分確認

## 🔗 参考リンク

- [chezmoi暗号化ガイド](https://www.chezmoi.io/user-guide/encryption/)
- [age暗号化ツール](https://age-encryption.org/)
- [GitHubセキュリティベストプラクティス](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure) 