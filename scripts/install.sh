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

# GitLeaks インストール
echo -e "${YELLOW}GitLeaks確認中...${RESET}"
if ! command -v gitleaks >/dev/null 2>&1; then
    echo -e "${BLUE}GitLeaksをインストールしています...${RESET}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install gitleaks
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        wget -O gitleaks.tar.gz "https://github.com/gitleaks/gitleaks/releases/download/v8.21.0/gitleaks_8.21.0_linux_x64.tar.gz"
        tar -xzf gitleaks.tar.gz
        if [[ "$IS_CI" == "true" ]]; then
            # CI環境では/usr/local/binに配置
            mkdir -p ~/.local/bin
            mv gitleaks ~/.local/bin/
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        else
            sudo mv gitleaks /usr/local/bin/
        fi
        rm gitleaks.tar.gz
    fi
fi
if command -v gitleaks >/dev/null 2>&1; then
    echo -e "  ✅ GitLeaks"
else
    echo -e "  ❌ GitLeaks"
fi

# TruffleHog インストール
echo -e "${YELLOW}TruffleHog確認中...${RESET}"
if ! command -v trufflehog >/dev/null 2>&1; then
    echo -e "${BLUE}TruffleHogをインストールしています...${RESET}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install trufflesecurity/trufflehog/trufflehog
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        wget -O trufflehog.tar.gz "https://github.com/trufflesecurity/trufflehog/releases/download/v3.63.2/trufflehog_3.63.2_linux_amd64.tar.gz"
        tar -xzf trufflehog.tar.gz
        if [[ "$IS_CI" == "true" ]]; then
            # CI環境では~/.local/binに配置
            mkdir -p ~/.local/bin
            mv trufflehog ~/.local/bin/
        else
            sudo mv trufflehog /usr/local/bin/
        fi
        rm trufflehog.tar.gz
    fi
fi
if command -v trufflehog >/dev/null 2>&1; then
    echo -e "  ✅ TruffleHog"
else
    echo -e "  ❌ TruffleHog"
fi

# 設定ファイルの作成
echo -e "${BLUE}⚙️  セキュリティツール設定ファイル作成中...${RESET}"

# GitLeaks設定ファイル
cat > .gitleaks.toml << 'EOF'
# GitLeaks設定ファイル
[extend]
# デフォルトルールを使用
useDefault = true

[[rules]]
description = "Personal email patterns"
id = "personal-email"
regex = '''[a-zA-Z0-9._%+-]+@(gmail|yahoo|hotmail|outlook)\.com'''
tags = ["email", "personal"]

[allowlist]
description = "Allowlisted files"
files = [
    '''\.md$''',
    '''\.txt$''',
    '''LICENSE''',
    '''\.tmpl$''',
    '''\.gitleaks\.toml$''',
    '''\.trufflehog\.yml$''',
]

paths = [
    '''scripts/''',
    '''docs/''',
]
EOF

# TruffleHog設定ファイル
cat > .trufflehog.yml << 'EOF'
# TruffleHog設定ファイル
detectors:
  - name: "gitleaks"
    enabled: true
  - name: "generic-api-key"
    enabled: true

ignore:
  paths:
    - "*.md"
    - "*.txt"
    - "LICENSE"
    - "docs/"
    - "scripts/"

verification: true
EOF

echo -e "  ✅ 設定ファイル作成完了"

# Git hooks セットアップ（非CI環境のみ）
if [[ "$IS_CI" != "true" ]] && [[ -d ".git" ]]; then
    echo -e "${BLUE}🪝 Git hooks セットアップ中...${RESET}"
    if [[ -f "scripts/setup-git-hooks.sh" ]]; then
        chmod +x scripts/setup-git-hooks.sh
        ./scripts/setup-git-hooks.sh
        echo -e "  ✅ Git hooks セットアップ完了"
    else
        echo -e "  ${YELLOW}⚠️  Git hooks スクリプトが見つかりません${RESET}"
    fi
fi

echo -e "${GREEN}✅ インストール完了！${RESET}"
echo -e "${YELLOW}📝 暗号化されたファイルがある場合は、AGE_SECRET_KEYを設定してください。${RESET}"

# 簡単なセキュリティチェック実行（CI環境でも実行）
echo -e "${BLUE}🔍 セキュリティチェック実行中...${RESET}"
if command -v gitleaks >/dev/null 2>&1; then
    echo -e "${YELLOW}GitLeaksでスキャン中...${RESET}"
    if gitleaks detect --source . --config .gitleaks.toml --verbose; then
        echo -e "  ✅ GitLeaks: 問題なし"
    else
        echo -e "  ${YELLOW}⚠️  GitLeaks: 潜在的な問題を発見${RESET}"
    fi
fi

echo -e "${GREEN}🎉 セットアップ完了！${RESET}"
echo -e "${BLUE}使用可能なコマンド:${RESET}"
echo -e "  make security-check-gitleaks  - GitLeaksでスキャン"
echo -e "  make security-check-trufflehog - TruffleHogでスキャン"
echo -e "  make security-check-all       - 全ツールでスキャン" 