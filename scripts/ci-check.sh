#!/bin/bash
set -euo pipefail

# Colors for output
GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

EXIT_CODE=0

echo -e "${BLUE}🔍 Dotfiles CI チェックを実行中...${RESET}"

# 1. Nix flake check
# checks.lint（shellcheck / stylua / nixfmt / statix / deadnix）を含む。
# 対象は git 追跡ファイルのみ。未追跡ファイルは pre-commit の lint-staged が拾う。
echo -e "${YELLOW}1. Nix flake check（lint 含む）...${RESET}"
if command -v nix >/dev/null 2>&1; then
    if nix flake check; then
        echo -e "  ✅ nix flake check passed"
    else
        echo -e "  ❌ nix flake check failed"
        EXIT_CODE=1
    fi
    if nix build ".#darwinConfigurations.${FLAKE_TARGET:-yuucu-mac}.system" --dry-run; then
        echo -e "  ✅ nix build dry-run passed"
    else
        echo -e "  ❌ nix build dry-run failed"
        EXIT_CODE=1
    fi
else
    echo -e "  ${RED}❌ nix not installed（lint がスキップされるため必須）${RESET}"
    EXIT_CODE=1
fi

# 2. Secret scan
echo -e "${YELLOW}2. Secret scan (gitleaks)...${RESET}"
if command -v gitleaks >/dev/null 2>&1; then
    if gitleaks git . --no-banner --redact; then
        echo -e "  ✅ gitleaks passed"
    else
        echo -e "  ❌ gitleaks found secrets"
        EXIT_CODE=1
    fi
else
    echo -e "  ${YELLOW}⚠️  gitleaks not installed${RESET}"
    echo -e "    ${BLUE}Install: home.packages 管理（make switch で導入）${RESET}"
fi

# Summary
echo -e "\n${BLUE}📊 CI Check Summary${RESET}"
if [ "${EXIT_CODE:-0}" -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed!${RESET}"
else
    echo -e "${RED}❌ Some checks failed. See details above.${RESET}"
    exit 1
fi
