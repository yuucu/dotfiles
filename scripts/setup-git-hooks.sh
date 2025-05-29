#!/bin/bash
#
# Git hooks setup script
# セキュリティチェック用のpre-commitフックを設定
#

set -euo pipefail

# Colors for output
GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
RESET='\033[0m'

echo -e "${BLUE}🔧 Git hooks セットアップ中...${RESET}"

# Git hooksディレクトリの確認
HOOKS_DIR=".git/hooks"
if [ ! -d "$HOOKS_DIR" ]; then
    echo -e "${YELLOW}⚠️  .git/hooksディレクトリが見つかりません${RESET}"
    echo -e "   Gitリポジトリ内で実行してください"
    exit 1
fi

# Pre-commitフックのセットアップ
PRE_COMMIT_HOOK="$HOOKS_DIR/pre-commit"
SECURITY_SCRIPT="scripts/pre-commit-security-check.sh"

if [ ! -f "$SECURITY_SCRIPT" ]; then
    echo -e "${YELLOW}⚠️  セキュリティチェックスクリプトが見つかりません: $SECURITY_SCRIPT${RESET}"
    exit 1
fi

# 既存のpre-commitフックのバックアップ
if [ -f "$PRE_COMMIT_HOOK" ]; then
    echo -e "${YELLOW}📁 既存のpre-commitフックをバックアップ中...${RESET}"
    cp "$PRE_COMMIT_HOOK" "$PRE_COMMIT_HOOK.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Pre-commitフックの作成
echo -e "${BLUE}📝 Pre-commitフックを作成中...${RESET}"
cat > "$PRE_COMMIT_HOOK" << 'EOF'
#!/bin/bash
#
# Pre-commit hook with security checks
#

# Get the directory of this script (should be .git/hooks)
HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$HOOK_DIR/../.." && pwd)"

cd "$REPO_ROOT"

# Run security checks
if [ -f "scripts/pre-commit-security-check.sh" ]; then
    echo "🔒 Running security checks..."
    ./scripts/pre-commit-security-check.sh
    SECURITY_EXIT_CODE=$?
    
    if [ $SECURITY_EXIT_CODE -ne 0 ]; then
        echo ""
        echo "❌ Security checks failed. Commit aborted."
        echo "   Fix the issues above or use --no-verify to skip."
        exit 1
    fi
else
    echo "⚠️  Security check script not found, skipping..."
fi

echo "✅ Pre-commit checks completed successfully."
EOF

# Pre-commitフックを実行可能にする
chmod +x "$PRE_COMMIT_HOOK"

echo -e "${GREEN}✅ Git hooks セットアップ完了${RESET}"
echo -e "${BLUE}📋 セットアップ内容:${RESET}"
echo -e "  • Pre-commit hook: $PRE_COMMIT_HOOK"
echo -e "  • セキュリティチェック: $SECURITY_SCRIPT"
echo -e ""
echo -e "${YELLOW}📝 使用方法:${RESET}"
echo -e "  • 通常のコミット: git commit -m \"message\""
echo -e "  • フックスキップ: git commit --no-verify -m \"message\""
echo -e "  • 手動チェック: ./scripts/pre-commit-security-check.sh" 