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

# 1. Shell script linting
echo -e "${YELLOW}1. Shell script linting (shellcheck)...${RESET}"
if command -v shellcheck >/dev/null 2>&1; then
    if find scripts/ -name "*.sh" -exec shellcheck {} +; then
        echo -e "  ✅ shellcheck passed"
    else
        echo -e "  ❌ shellcheck failed"
        EXIT_CODE=1
    fi
else
    echo -e "  ${YELLOW}⚠️  shellcheck not installed${RESET}"
    echo -e "    ${BLUE}Install: home.packages 管理（make switch で導入）${RESET}"
fi

# 2. Lua formatting check
echo -e "${YELLOW}2. Lua formatting check...${RESET}"
if command -v stylua >/dev/null 2>&1; then
    if [ -d "config/nvim" ]; then
        if stylua --check config/nvim/; then
            echo -e "  ✅ Lua formatting check passed"
        else
            echo -e "  ❌ Lua formatting check failed"
            echo -e "    ${BLUE}Run: stylua config/nvim/${RESET}"
            EXIT_CODE=1
        fi
    fi
else
    echo -e "  ${YELLOW}⚠️  stylua not installed${RESET}"
    echo -e "    ${BLUE}Install: home.packages 管理（make switch で導入）${RESET}"
fi

# 3. Nix flake check
echo -e "${YELLOW}3. Nix flake check...${RESET}"
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
    echo -e "  ${YELLOW}⚠️  nix not installed（ローカルではスキップ可）${RESET}"
fi

# 4. Basic file structure check
echo -e "${YELLOW}4. Basic file structure check...${RESET}"
required_files=(
    "README.md"
    "Makefile"
    "flake.nix"
    "darwin/default.nix"
    "home/default.nix"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "  ✅ $file"
    else
        echo -e "  ❌ $file (missing)"
        EXIT_CODE=1
    fi
done

# Summary
echo -e "\n${BLUE}📊 CI Check Summary${RESET}"
if [ "${EXIT_CODE:-0}" -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed!${RESET}"
else
    echo -e "${RED}❌ Some checks failed. See details above.${RESET}"
    exit 1
fi
