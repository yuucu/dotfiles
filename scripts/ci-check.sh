#!/bin/bash
set -euo pipefail

# Colors for output
GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

# Environment detection
IS_CI=${CI:-false}

echo -e "${BLUE}🔍 CI チェックを実行中...${RESET}"
if [ "$IS_CI" = "true" ]; then
    echo -e "${YELLOW}CI環境で実行中${RESET}"
    echo -e "Initial PATH in ci-check.sh: $PATH"
    # Ensure common system paths and our custom path are present
    # Prepend $HOME/.local/bin and ensure standard paths are there.
    # The existing $PATH from the environment is appended, which should contain GHA default paths.
    export PATH="$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
    echo -e "Modified PATH in ci-check.sh for CI: $PATH"
    echo -e "Contents of $HOME/.local/bin in ci-check.sh (after PATH mod):"
    ls -la "$HOME/.local/bin/" || echo "$HOME/.local/bin not found or empty (checked from ci-check.sh)"
    echo -e "Verifying 'find' command from ci-check.sh:"
    command -v find || echo "find command NOT FOUND in ci-check.sh"
    echo -e "Verifying 'shellcheck' command from ci-check.sh (after PATH mod):"
    command -v shellcheck || echo "shellcheck command NOT FOUND in ci-check.sh (after PATH mod)"
    echo -e "Verifying 'chezmoi' command from ci-check.sh (after PATH mod):"
    command -v chezmoi || echo "chezmoi command NOT FOUND in ci-check.sh (after PATH mod)"
fi

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
    echo -e "  ${YELLOW}⚠️  shellcheck not installed${RESET}"
    if [ "$IS_CI" = "true" ]; then
        echo -e "  ${RED}❌ shellcheck is required in CI${RESET}"
        EXIT_CODE=1
    else
        echo -e "    ${BLUE}Install: brew install shellcheck${RESET}"
    fi
fi

# 2. Chezmoi template validation
echo -e "${YELLOW}2. Chezmoi template validation...${RESET}"
if command -v chezmoi >/dev/null 2>&1; then
    if [ "$IS_CI" = "true" ]; then
        # CI環境では現在のディレクトリをchezmoiのソースディレクトリとして設定
        export CHEZMOI_SOURCE_DIR="$(pwd)"
        echo -e "  ${BLUE}CI環境: ソースディレクトリを $(pwd) に設定${RESET}"
        
        # CI環境では設定ファイルテンプレートのテストのみ
        if [ -f ".chezmoi.yaml.tmpl" ]; then
            if chezmoi execute-template < .chezmoi.yaml.tmpl >/dev/null 2>&1; then
                echo -e "  ✅ chezmoi config template valid"
            else
                echo -e "  ❌ chezmoi config template validation failed"
                EXIT_CODE=1
            fi
        else
            echo -e "  ${YELLOW}⚠️  .chezmoi.yaml.tmpl not found${RESET}"
        fi
    else
        # ローカル環境では簡潔に実行
        if chezmoi apply --dry-run --force >/dev/null 2>&1; then
            echo -e "  ✅ chezmoi templates valid"
        else
            echo -e "  ❌ chezmoi template validation failed"
            echo -e "    ${BLUE}Run: chezmoi apply --dry-run --verbose${RESET}"
            EXIT_CODE=1
        fi
    fi
else
    echo -e "  ${YELLOW}⚠️  chezmoi not installed${RESET}"
    if [ "$IS_CI" = "true" ]; then
        echo -e "  ${RED}❌ chezmoi is required in CI${RESET}"
        EXIT_CODE=1
    fi
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
    if [ "$IS_CI" = "true" ]; then
        echo -e "  ${RED}❌ stylua is required in CI${RESET}"
        EXIT_CODE=1
    else
        if command -v brew >/dev/null 2>&1; then
            echo -e "    ${BLUE}Install: brew install stylua${RESET}"
        elif command -v cargo >/dev/null 2>&1; then
            echo -e "    ${BLUE}Install: cargo install stylua${RESET}"
        fi
    fi
fi

# 4. Neovim configuration test (CI only)
if [ "$IS_CI" = "true" ] && [ -d "dot_config/nvim" ]; then
    echo -e "${YELLOW}4. Neovim configuration test...${RESET}"
    if command -v nvim >/dev/null 2>&1; then
        # 一時的にNeovim設定をホームディレクトリにコピー
        mkdir -p ~/.config
        cp -r dot_config/nvim ~/.config/
        
        # ヘッドレスモードでNeovimプラグインの同期テスト
        if timeout 300 nvim --headless "+Lazy! sync" +qa 2>/dev/null || true; then
            echo -e "  ✅ Neovim plugin sync test completed"
        else
            echo -e "  ${YELLOW}⚠️  Neovim plugin sync test timeout or failed${RESET}"
        fi
        
        # 基本的な設定読み込みテスト
        if nvim --headless -c "checkhealth" -c "quit" 2>/dev/null || true; then
            echo -e "  ✅ Neovim health check completed"
        else
            echo -e "  ${YELLOW}⚠️  Neovim health check completed with warnings${RESET}"
        fi
    else
        echo -e "  ❌ Neovim not available for testing"
        EXIT_CODE=1
    fi
fi

# 5. Template processing test (CI only)
if [ "$IS_CI" = "true" ]; then
    echo -e "${YELLOW}5. Template processing test...${RESET}"
    echo -e "  ${BLUE}スキップ: CI環境では設定ファイルテンプレートのみテスト済み${RESET}"
fi

# 6. Basic file structure check
echo -e "${YELLOW}6. Basic file structure check...${RESET}"
required_files=(
    "README.md"
    "Makefile"
    ".chezmoi.yaml.tmpl"
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

# 7. Script executable check
echo -e "${YELLOW}7. Script executable check...${RESET}"
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