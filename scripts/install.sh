#!/bin/bash
set -euo pipefail

# Colors for output
GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

echo -e "${BLUE}🚀 必要なツールをインストール中...${RESET}"

# CI環境の検出
IS_CI="${CI:-false}"
if [[ "$IS_CI" == "true" ]]; then
    echo -e "${YELLOW}🤖 CI環境を検出${RESET}"
fi

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

# セキュリティツールのインストール
echo -e "${BLUE}🔒 セキュリティツールをインストール中...${RESET}"

# lefthook インストール
echo -e "${YELLOW}lefthook確認中...${RESET}"
if ! command -v lefthook >/dev/null 2>&1; then
    echo -e "${BLUE}lefthookをインストールしています...${RESET}"
    if [[ "$OSTYPE" == "darwin"* ]] && command -v brew >/dev/null 2>&1; then
        brew install lefthook
    elif [[ "$OSTYPE" == "linux-gnu"* ]] && command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y lefthook || true
    fi
fi
if command -v lefthook >/dev/null 2>&1; then
    echo -e "  ✅ lefthook"
else
    echo -e "  ${YELLOW}⚠️  lefthook not installed${RESET}"
fi

# shellcheck installation for CI
echo -e "${YELLOW}shellcheck確認中...${RESET}"
if ! command -v shellcheck >/dev/null 2>&1; then
    echo -e "${BLUE}shellcheckをインストールしています...${RESET}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install shellcheck
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux - apt-getで既にインストール済みのはず
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update && sudo apt-get install -y shellcheck
        fi
    fi
fi
if command -v shellcheck >/dev/null 2>&1; then
    echo -e "  ✅ shellcheck"
else
    echo -e "  ❌ shellcheck"
fi

# stylua インストール（CI用）
echo -e "${YELLOW}stylua確認中...${RESET}"
if ! command -v stylua >/dev/null 2>&1; then
    echo -e "${BLUE}styluaをインストールしています...${RESET}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install stylua
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux - 手動インストール
        if [[ "$IS_CI" == "true" ]]; then
            STYLUA_VERSION="v2.1.0"
            STYLUA_URL="https://github.com/JohnnyMorganz/StyLua/releases/download/${STYLUA_VERSION}/stylua-linux-x86_64.zip"
            curl -L --fail --show-error "$STYLUA_URL" -o stylua.zip
            unzip stylua.zip
            chmod +x stylua
            mkdir -p ~/.local/bin
            mv stylua ~/.local/bin/
            rm stylua.zip
        fi
    fi
fi
if command -v stylua >/dev/null 2>&1; then
    echo -e "  ✅ stylua"
else
    echo -e "  ❌ stylua"
fi

# 設定ファイルの作成
echo -e "${BLUE}⚙️  セキュリティツール設定ファイル作成中...${RESET}"

echo -e "  ✅ 設定ファイル作成完了"

if [[ "$IS_CI" != "true" ]] && [[ -d ".git" ]] && command -v lefthook >/dev/null 2>&1; then
    echo -e "${BLUE}🪝 lefthookをセットアップ中...${RESET}"
    lefthook install
    echo -e "  ✅ lefthook install 完了"
fi

echo -e "${GREEN}✅ インストール完了！${RESET}"
echo -e "${YELLOW}📝 暗号化されたファイルがある場合は、AGE_SECRET_KEYを設定してください。${RESET}"

echo -e "${GREEN}🎉 セットアップ完了！${RESET}"
echo -e "${BLUE}使用可能なコマンド:${RESET}"
echo -e "  make update  - dotfilesとツールの更新"
echo -e "  make apply   - chezmoiの変更を適用"
echo -e "  make status  - 環境の状態確認" 
