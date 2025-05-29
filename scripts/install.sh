#!/bin/bash
set -euo pipefail

# Colors for output
GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

echo -e "${BLUE}🚀 必要なツールをインストール中...${RESET}"

# chezmoi確認・インストール
echo -e "${YELLOW}chezmoi確認中...${RESET}"
if ! command -v chezmoi >/dev/null 2>&1; then
    echo -e "${BLUE}chezmoiをインストールしています...${RESET}"
    sh -c "$(curl -fsLS get.chezmoi.io)"
fi
if command -v chezmoi >/dev/null 2>&1; then
    echo -e "  ✅ chezmoi"
else
    echo -e "  ❌ chezmoi"
fi

# age確認・インストール
echo -e "${YELLOW}age確認中...${RESET}"
if ! command -v age >/dev/null 2>&1; then
    echo -e "${BLUE}ageをインストールしています...${RESET}"
    if command -v brew >/dev/null 2>&1; then
        brew install age
    elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y age
    else
        echo -e "${RED}❌ パッケージマネージャーが見つかりません。手動でageをインストールしてください。${RESET}"
    fi
fi
if command -v age >/dev/null 2>&1; then
    echo -e "  ✅ age"
else
    echo -e "  ❌ age"
fi

# Neovim確認
echo -e "${YELLOW}Neovim確認中...${RESET}"
if command -v nvim >/dev/null 2>&1; then
    nvim_version=$(nvim --version | head -n1 | sed 's/NVIM v//')
    echo -e "  ✅ Neovim ${nvim_version}"
else
    echo -e "  ${YELLOW}⚠️  Neovimが見つかりません。手動でインストールを推奨します。${RESET}"
    if command -v brew >/dev/null 2>&1; then
        echo -e "    ${BLUE}brew install neovim${RESET}"
    elif command -v apt-get >/dev/null 2>&1; then
        echo -e "    ${BLUE}sudo apt-get install neovim${RESET}"
    fi
fi

# mise確認・インストール
echo -e "${BLUE}📦 miseをインストール中...${RESET}"
if ! command -v mise >/dev/null 2>&1; then
    echo -e "${YELLOW}miseをインストールしています...${RESET}"
    if command -v brew >/dev/null 2>&1; then
        brew install mise
    elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y mise
    else
        curl https://mise.run | sh
    fi
fi
if command -v mise >/dev/null 2>&1; then
    echo -e "  ✅ mise"
else
    echo -e "  ❌ mise"
fi

# miseランタイムインストール
echo -e "${BLUE}🔧 ランタイムをインストール中...${RESET}"
if command -v mise >/dev/null 2>&1; then
    mise install || echo -e "${YELLOW}⚠️  miseランタイムのインストールをスキップ${RESET}"
else
    echo -e "${YELLOW}⚠️  miseが利用できないため、ランタイムインストールをスキップ${RESET}"
fi

echo -e "${GREEN}✅ インストール完了！${RESET}"
echo -e "${YELLOW}📝 暗号化されたファイルがある場合は、AGE_SECRET_KEYを設定してください。${RESET}" 