# Makefile for dotfiles management (nix-darwin + home-manager)
# ================================

.PHONY: help switch check update fmt gc ci-check hook-install status

# username は実ログインユーザーに追従（flake.nix が DOTFILES_USER を参照）。
# sudo 実行下でも元のユーザーを拾うため SUDO_USER を優先する。
DOTFILES_USER := $(shell echo $${SUDO_USER:-$$(whoami)})
FLAKE_TARGET := $(DOTFILES_USER)-mac
export DOTFILES_USER

# Colors for output
GREEN := \033[32m
BLUE := \033[34m
YELLOW := \033[33m
RESET := \033[0m

help: ## このヘルプメッセージを表示
	@echo "$(BLUE)dotfiles管理用Makefile$(RESET)"
	@echo "================================"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2}'

switch: ## 🔄 flake の変更をシステムに適用（darwin-rebuild switch）
	@sudo DOTFILES_USER=$(DOTFILES_USER) /run/current-system/sw/bin/darwin-rebuild switch --impure --flake .#$(FLAKE_TARGET)

check: ## 🔍 flake の評価チェック（適用はしない）
	@nix flake check
	@nix build .#darwinConfigurations.$(FLAKE_TARGET).system --dry-run --impure

update: ## 📦 flake inputs・Neovim プラグイン・mise ツールの更新
	@echo "$(BLUE)📦 flake inputs を更新中...$(RESET)"
	@nix flake update
	@echo "$(BLUE)🔍 更新後の評価チェック（NG なら switch せず終了）...$(RESET)"
	@$(MAKE) check
	@git --no-pager diff --stat flake.lock
	@$(MAKE) switch
	@echo "$(BLUE)🔌 Neovim プラグインを更新中...$(RESET)"
	@command -v nvim >/dev/null 2>&1 && nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
	@echo "$(BLUE)🔄 mise 管理ツールを更新中...$(RESET)"
	@command -v mise >/dev/null 2>&1 && mise upgrade || true
	@echo "$(GREEN)✅ 全体更新完了$(RESET)"

fmt: ## 🎨 nix ファイルを整形（nix fmt）
	@nix fmt

# nix.enable = false（Determinate installer 管理）のため nix-darwin の
# 自動 GC は使えない。unstable 追従で store が肥大するので定期的に実行する。
gc: ## 🗑  30 日より古い世代を削除して Nix store を GC
	@sudo nix-collect-garbage --delete-older-than 30d
	@nix-collect-garbage --delete-older-than 30d

ci-check: ## 🔍 CI と同じチェックをローカルで実行
	@chmod +x scripts/ci-check.sh
	@scripts/ci-check.sh

hook-install: ## 🪝 lefthook をインストール
	@lefthook install

status: ## 📊 環境の状態確認
	@echo "$(YELLOW)必須ツール:$(RESET)"
	@command -v nix >/dev/null 2>&1 && echo "  ✅ nix ($$(nix --version))" || echo "  ❌ nix"
	@command -v darwin-rebuild >/dev/null 2>&1 && echo "  ✅ darwin-rebuild" || echo "  ❌ darwin-rebuild（初回は README のセットアップ参照）"
	@command -v mise >/dev/null 2>&1 && echo "  ✅ mise" || echo "  ❌ mise"
	@echo "$(YELLOW)symlink 状態（home-manager）:$(RESET)"
	@ls -l ~/.zshrc ~/.config/nvim 2>/dev/null || echo "  未適用"
