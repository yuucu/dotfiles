#!/bin/bash
#
# Git pre-commit hook for security checks
# 機密情報のコミットを防ぐためのチェックスクリプト
#

set -euo pipefail

# Colors for output
RED='\033[31m'
YELLOW='\033[33m'
GREEN='\033[32m'
BLUE='\033[34m'
RESET='\033[0m'

echo -e "${BLUE}🔒 セキュリティチェックを実行中...${RESET}"

# フラグ変数
ISSUES_FOUND=0

# 1. 機密情報パターンのチェック
echo -e "${YELLOW}1. 機密情報パターンチェック...${RESET}"

# チェック対象のパターン
SENSITIVE_PATTERNS=(
    # API Keys and Tokens
    "api[_-]?key\s*[:=]\s*['\"]?[a-zA-Z0-9_-]{16,}"
    "secret[_-]?key\s*[:=]\s*['\"]?[a-zA-Z0-9_-]{16,}"
    "access[_-]?token\s*[:=]\s*['\"]?[a-zA-Z0-9_-]{16,}"
    "bearer\s+[a-zA-Z0-9_-]{16,}"
    
    # Database passwords
    "password\s*[:=]\s*['\"]?[^'\"\\s]{8,}"
    "db[_-]?pass\s*[:=]\s*['\"]?[^'\"\\s]{8,}"
    
    # Private keys
    "BEGIN\s+(RSA\s+)?PRIVATE\s+KEY"
    "ssh-rsa\s+[A-Za-z0-9+/]"
    "ssh-ed25519\s+[A-Za-z0-9+/]"
    
    # URLs with embedded credentials
    "https?://[^:]+:[^@]+@"
    
    # AWS credentials
    "AKIA[0-9A-Z]{16}"
    "aws[_-]?secret[_-]?access[_-]?key"
    
    # GitHub tokens
    "ghp_[a-zA-Z0-9]{36}"
    "gho_[a-zA-Z0-9]{36}"
    "ghu_[a-zA-Z0-9]{36}"
    "ghs_[a-zA-Z0-9]{36}"
    "ghr_[a-zA-Z0-9]{36}"
)

# ステージングされたファイルを取得
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

if [ -z "$STAGED_FILES" ]; then
    echo -e "  ${GREEN}✅ ステージングされたファイルがありません${RESET}"
else
    # 除外するファイルパターン
    EXCLUDE_PATTERNS=(
        "*.age"                    # 暗号化ファイル
        "*.gpg"                    # GPG暗号化ファイル
        "*.enc"                    # 暗号化ファイル
        "SECURITY.md"              # セキュリティドキュメント（例を含む）
        "*.example"                # 例ファイル
        "*.sample"                 # サンプルファイル
        "docs/"                    # ドキュメントフォルダ
        ".chezmoiignore"           # chezmoiの除外設定
        "scripts/pre-commit-security-check.sh"  # このスクリプト自体
    )
    
    for file in $STAGED_FILES; do
        # 除外ファイルをスキップ
        SKIP=false
        for pattern in "${EXCLUDE_PATTERNS[@]}"; do
            if [[ "$file" == $pattern* ]]; then
                SKIP=true
                break
            fi
        done
        
        if [ "$SKIP" = true ]; then
            continue
        fi
        
        # ファイルが存在し、テキストファイルの場合のみチェック
        if [ -f "$file" ] && file "$file" | grep -q "text"; then
            for pattern in "${SENSITIVE_PATTERNS[@]}"; do
                if git show ":$file" | grep -qiE "$pattern"; then
                    echo -e "  ${RED}❌ 機密情報検出: $file${RESET}"
                    echo -e "     ${YELLOW}パターン: $pattern${RESET}"
                    ISSUES_FOUND=1
                fi
            done
        fi
    done
fi

# 2. ハードコードされた個人情報チェック
echo -e "${YELLOW}2. 個人情報チェック...${RESET}"

PERSONAL_PATTERNS=(
    "/Users/[^/]+/"              # macOSの絶対パス
    "/home/[^/]+/"               # Linuxの絶対パス
    "C:\\\\Users\\\\[^\\\\]+\\\\" # Windowsの絶対パス
    "@gmail\\.com"               # Gmail（除外設定で許可されたもの以外）
    "@[a-zA-Z0-9.-]+\\.(co\\.jp|com|net|org)" # その他のメールアドレス
)

PERSONAL_EXCLUDE_FILES=(
    ".chezmoi.yaml"              # chezmoiの設定（意図的にメールアドレスを含む）
    "README.md"                  # READMEには例として含まれる可能性
    "docs/"                      # ドキュメント
    "scripts/pre-commit-security-check.sh"  # このスクリプト自体
)

for file in $STAGED_FILES; do
    # 除外ファイルをスキップ
    SKIP=false
    for exclude_file in "${PERSONAL_EXCLUDE_FILES[@]}"; do
        if [[ "$file" == $exclude_file* ]]; then
            SKIP=true
            break
        fi
    done
    
    if [ "$SKIP" = true ]; then
        continue
    fi
    
    if [ -f "$file" ] && file "$file" | grep -q "text"; then
        for pattern in "${PERSONAL_PATTERNS[@]}"; do
            if git show ":$file" | grep -qE "$pattern"; then
                echo -e "  ${RED}❌ 個人情報検出: $file${RESET}"
                echo -e "     ${YELLOW}パターン: $pattern${RESET}"
                ISSUES_FOUND=1
            fi
        done
    fi
done

# 3. 結果の判定
echo -e "\n${BLUE}📊 セキュリティチェック結果${RESET}"

if [ $ISSUES_FOUND -eq 1 ]; then
    echo -e "${RED}❌ セキュリティ問題が検出されました！${RESET}"
    echo -e "${YELLOW}以下の対策を検討してください：${RESET}"
    echo -e "  • 機密情報をchezmoiテンプレート変数に移動"
    echo -e "  • .chezmoiignoreに追加"
    echo -e "  • age暗号化を使用"
    echo -e "  • 環境変数として管理"
    echo -e "\n${BLUE}詳細: docs/environment.md を参照${RESET}"
    exit 1
else
    echo -e "${GREEN}✅ セキュリティチェック完了 - 問題なし${RESET}"
fi 