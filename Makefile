# Makefile for dotfiles management (nix-darwin + home-manager)
# ================================

.PHONY: help switch check update ci-check hook-install status

FLAKE_TARGET := yuucu-mac

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
	@sudo /run/current-system/sw/bin/darwin-rebuild switch --flake .#$(FLAKE_TARGET)

check: ## 🔍 flake の評価チェック（適用はしない）
	@nix flake check
	@nix build .#darwinConfigurations.$(FLAKE_TARGET).system --dry-run

update: ## 📦 flake inputs・Neovim プラグイン・mise ツールの更新
	@echo "$(BLUE)📦 flake inputs を更新中...$(RESET)"
	@nix flake update
	@$(MAKE) switch
	@echo "$(BLUE)🔌 Neovim プラグインを更新中...$(RESET)"
	@command -v nvim >/dev/null 2>&1 && nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
	@echo "$(BLUE)🔄 mise 管理ツールを更新中...$(RESET)"
	@command -v mise >/dev/null 2>&1 && mise upgrade || true
	@echo "$(GREEN)✅ 全体更新完了$(RESET)"

ci-check: ## 🔍 CI と同じチェックをローカルで実行
	@chmod +x scripts/ci-check.sh
	@FLAKE_TARGET=$(FLAKE_TARGET) scripts/ci-check.sh

hook-install: ## 🪝 lefthook をインストール
	@lefthook install

status: ## 📊 環境の状態確認
	@echo "$(YELLOW)必須ツール:$(RESET)"
	@command -v nix >/dev/null 2>&1 && echo "  ✅ nix ($$(nix --version))" || echo "  ❌ nix"
	@command -v darwin-rebuild >/dev/null 2>&1 && echo "  ✅ darwin-rebuild" || echo "  ❌ darwin-rebuild（初回は README のセットアップ参照）"
	@command -v mise >/dev/null 2>&1 && echo "  ✅ mise" || echo "  ❌ mise"
	@echo "$(YELLOW)symlink 状態（home-manager）:$(RESET)"
	@ls -l ~/.zshrc ~/.config/nvim 2>/dev/null || echo "  未適用"
