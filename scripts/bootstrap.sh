#!/bin/bash
set -euo pipefail

# ============================================================================
# dotfiles bootstrap (macOS)
#
# 新しい Mac で以下を非対話・冪等に実行する:
#   1. Xcode Command Line Tools
#   2. Homebrew
#   3. Nix (Determinate Systems installer)
#   4. dotfiles の clone
#   5. nix-darwin の初回適用（darwin-rebuild switch）
#
# 使い方（ワンライナー）:
#   curl -fsSL https://raw.githubusercontent.com/yuucu/dotfiles/main/scripts/bootstrap.sh | bash
#
# 適用後の手作業（このスクリプトでは扱わない・最後に案内する）:
#   - local/ の作成（work の git identity・社内 URL 等。git 管理外）
#   - シェルの開き直し（zinit・プラグインは初回起動時に自動インストール）
#   - mise install / gh auth login などツール個別のログイン
# ============================================================================

GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

REPO_URL="https://github.com/yuucu/dotfiles"
REPO_DIR="${HOME}/ghq/github.com/yuucu/dotfiles"
FLAKE_TARGET="yuucu-mac"

log() { echo -e "${BLUE}==> $*${RESET}"; }
ok() { echo -e "  ${GREEN}✅ $*${RESET}"; }
warn() { echo -e "  ${YELLOW}⚠️  $*${RESET}"; }
err() { echo -e "  ${RED}❌ $*${RESET}"; }

if [ "$(uname -s)" != "Darwin" ]; then
    err "このスクリプトは macOS 専用です（uname: $(uname -s)）"
    exit 1
fi

# ----------------------------------------------------------------------------
# 1. Xcode Command Line Tools
# ----------------------------------------------------------------------------
log "1/5 Xcode Command Line Tools"
if xcode-select -p >/dev/null 2>&1; then
    ok "既にインストール済み"
else
    warn "インストールを開始します（GUI ダイアログが開きます）"
    xcode-select --install || true
    echo -e "  ${YELLOW}ダイアログでインストールを完了させてから Enter を押してください${RESET}"
    read -r _
    xcode-select -p >/dev/null 2>&1 || {
        err "Xcode CLT が見つかりません。インストール完了後に再実行してください"
        exit 1
    }
    ok "インストール完了"
fi

# ----------------------------------------------------------------------------
# 2. Homebrew
# ----------------------------------------------------------------------------
log "2/5 Homebrew"
if command -v brew >/dev/null 2>&1; then
    ok "既にインストール済み（$(brew --version | head -1)）"
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # 現在のシェルに brew を通す（Apple Silicon / Intel 両対応）
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    ok "インストール完了"
fi

# ----------------------------------------------------------------------------
# 3. Nix (Determinate Systems installer)
# ----------------------------------------------------------------------------
log "3/5 Nix"
if command -v nix >/dev/null 2>&1; then
    ok "既にインストール済み（$(nix --version)）"
else
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm
    # 現在のシェルに nix を通す
    if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        # shellcheck disable=SC1091
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
    ok "インストール完了"
fi

# ----------------------------------------------------------------------------
# 4. dotfiles の clone
# ----------------------------------------------------------------------------
log "4/5 dotfiles clone"
if [ -d "${REPO_DIR}/.git" ]; then
    ok "既に clone 済み（${REPO_DIR}）"
else
    mkdir -p "$(dirname "${REPO_DIR}")"
    git clone "${REPO_URL}" "${REPO_DIR}"
    ok "clone 完了（${REPO_DIR}）"
fi

# ----------------------------------------------------------------------------
# 5. nix-darwin の初回適用
# ----------------------------------------------------------------------------
log "5/5 nix-darwin 初回適用（.#${FLAKE_TARGET}）"
cd "${REPO_DIR}"
if command -v darwin-rebuild >/dev/null 2>&1; then
    ok "darwin-rebuild が既にある → make switch で適用"
    sudo /run/current-system/sw/bin/darwin-rebuild switch --flake ".#${FLAKE_TARGET}"
else
    warn "初回のため nix run で nix-darwin を適用します（sudo でパスワードを求められます）"
    sudo nix run nix-darwin/master -- switch --flake ".#${FLAKE_TARGET}"
fi
ok "適用完了"

# ----------------------------------------------------------------------------
# 完了 & 手作業の案内
# ----------------------------------------------------------------------------
echo ""
echo -e "${GREEN}🎉 bootstrap 完了${RESET}"
echo ""
echo -e "${YELLOW}残りの手作業（最小限）:${RESET}"
echo "  1. local/ の作成（git 管理外。ないと ~/.gitconfig 等の symlink が空振りする）"
echo "     - local/gitconfig … identity と [include] path = ~/.gitconfig.local など"
echo "     - local/gitconfig-personal / local/gitconfig.local / local/zshrc.local"
echo "  2. シェルを開き直す（zinit・プラグインは初回起動時に自動インストール）"
echo "  3. mise install / gh auth login などツール個別のログイン"
echo ""
echo -e "  以降の適用は ${BLUE}cd ${REPO_DIR} && make switch${RESET}"
