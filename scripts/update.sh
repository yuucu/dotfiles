#!/bin/bash
set -euo pipefail

# Colors for output
GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
RESET='\033[0m'

echo -e "${BLUE}📦 dotfilesを更新中...${RESET}"
if command -v chezmoi >/dev/null 2>&1; then
    chezmoi update
    chezmoi apply
    echo -e "  ✅ dotfiles更新完了"
else
    echo -e "${YELLOW}⚠️  chezmoiが見つかりません。スキップします。${RESET}"
fi

echo -e "${BLUE}🔌 Neovimプラグインを更新中...${RESET}"
if command -v nvim >/dev/null 2>&1; then
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || echo -e "${YELLOW}⚠️  Neovimプラグイン更新をスキップ${RESET}"
    echo -e "  ✅ Neovimプラグイン更新完了"
else
    echo -e "${YELLOW}⚠️  Neovimが見つかりません。スキップします。${RESET}"
fi

echo -e "${BLUE}🔄 mise管理ツールを更新中...${RESET}"
if command -v mise >/dev/null 2>&1; then
    mise upgrade 2>/dev/null || echo -e "${YELLOW}⚠️  mise upgrade をスキップ${RESET}"
    mise install --all 2>/dev/null || echo -e "${YELLOW}⚠️  mise install をスキップ${RESET}"
    echo -e "  ✅ miseツール更新完了"
else
    echo -e "${YELLOW}⚠️  miseが見つかりません。スキップします。${RESET}"
fi

echo -e "${GREEN}✅ 全体更新完了${RESET}" 