#!/bin/bash
set -euo pipefail

# Colors for output
GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

echo -e "${BLUE}🔍 CI チェックをローカルで実行中...${RESET}"

# 1. Shell script linting
echo -e "${YELLOW}1. Shell script linting (shellcheck)...${RESET}"
if command -v shellcheck >/dev/null 2>&1; then
    if find scripts/ -name "*.sh" -exec shellcheck {} \; 2>/dev/null; then
        echo -e "  ✅ shellcheck passed"
    else
        echo -e "  ❌ shellcheck failed"
        EXIT_CODE=1
    fi
else
    echo -e "  ${YELLOW}⚠️  shellcheck not installed (brew install shellcheck)${RESET}"
fi

# 2. Chezmoi template validation
echo -e "${YELLOW}2. Chezmoi template validation...${RESET}"
if command -v chezmoi >/dev/null 2>&1; then
    if chezmoi apply --dry-run --force >/dev/null 2>&1; then
        echo -e "  ✅ chezmoi templates valid"
    else
        echo -e "  ❌ chezmoi template validation failed"
        echo -e "    ${BLUE}Run: chezmoi apply --dry-run --verbose${RESET}"
        EXIT_CODE=1
    fi
else
    echo -e "  ${YELLOW}⚠️  chezmoi not installed${RESET}"
fi

# 3. Lua formatting check (if stylua is available)
echo -e "${YELLOW}3. Lua formatting check...${RESET}"
if command -v stylua >/dev/null 2>&1; then
    if [ -d "dot_config/nvim" ]; then
        if stylua --check dot_config/nvim/ 2>/dev/null; then
            echo -e "  ✅ Lua formatting check passed"
        else
            echo -e "  ❌ Lua formatting check failed"
            echo -e "    ${BLUE}Run: stylua dot_config/nvim/${RESET}"
            EXIT_CODE=1
        fi
    else
        echo -e "  ${YELLOW}⚠️  dot_config/nvim directory not found${RESET}"
    fi
else
    echo -e "  ${YELLOW}⚠️  stylua not installed${RESET}"
    if command -v brew >/dev/null 2>&1; then
        echo -e "    ${BLUE}Install: brew install stylua${RESET}"
    elif command -v cargo >/dev/null 2>&1; then
        echo -e "    ${BLUE}Install: cargo install stylua${RESET}"
    fi
fi

# 4. Basic file structure check
echo -e "${YELLOW}4. Basic file structure check...${RESET}"
required_files=(
    "README.md"
    "Makefile"
    ".chezmoi.yaml"
    "scripts/install.sh"
    "scripts/update.sh"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "  ✅ $file"
    else
        echo -e "  ❌ $file (missing)"
        EXIT_CODE=1
    fi
done

# 5. Script executable check
echo -e "${YELLOW}5. Script executable check...${RESET}"
script_files=(
    "scripts/install.sh"
    "scripts/update.sh"
    "scripts/bootstrap.sh"
)

for script in "${script_files[@]}"; do
    if [ -f "$script" ]; then
        if [ -x "$script" ]; then
            echo -e "  ✅ $script (executable)"
        else
            echo -e "  ❌ $script (not executable)"
            echo -e "    ${BLUE}Fix: chmod +x $script${RESET}"
            EXIT_CODE=1
        fi
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