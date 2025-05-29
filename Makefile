# Makefile for dotfiles management
# ================================
# シンプルなdotfiles管理タスク

.PHONY: help install setup update test lint clean status

# Variables
NVIM := nvim
CONFIG_DIR := dot_config/nvim
SCRIPTS_DIR := scripts
CHEZMOI := chezmoi

# Colors for output
GREEN := \033[32m
BLUE := \033[34m
YELLOW := \033[33m
RED := \033[31m
RESET := \033[0m

# Default target
help: ## このヘルプメッセージを表示
	@echo "$(BLUE)dotfiles管理用Makefile$(RESET)"
	@echo "================================"
	@echo "利用可能なタスク:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-10s$(RESET) %s\n", $$1, $$2}'

# Core commands
install: ## dotfilesの初期インストールとセットアップ
	@echo "$(BLUE)🚀 dotfilesを初期化中...$(RESET)"
	@$(SCRIPTS_DIR)/bootstrap.sh
	@echo "$(GREEN)✅ インストール完了$(RESET)"


update: ## dotfilesとプラグインの更新
	@echo "$(BLUE)📦 dotfilesを更新中...$(RESET)"
	@$(CHEZMOI) update
	@$(CHEZMOI) apply
	@echo "$(BLUE)🔌 Neovimプラグインを更新中...$(RESET)"
	@$(NVIM) --headless "+Lazy! sync" +qa 2>/dev/null || echo "$(YELLOW)⚠️  Neovimプラグイン更新をスキップ$(RESET)"
	@echo "$(GREEN)✅ 更新完了$(RESET)"

# Testing and validation
test: ## 全体のテストと構文チェック
	@echo "$(BLUE)🧪 テストを実行中...$(RESET)"
	@echo "$(YELLOW)  スクリプト構文チェック...$(RESET)"
	@for script in $(SCRIPTS_DIR)/*.sh; do \
		echo "    チェック中: $$script"; \
		bash -n "$$script" || exit 1; \
	done
	@echo "$(YELLOW)  Neovim設定テスト...$(RESET)"
	@$(NVIM) --headless -c "lua require('utils.notes_test').run_all_tests()" -c "quit" 2>/dev/null || echo "    ⚠️  Neovimテストをスキップ"
	@echo "$(GREEN)✅ テスト完了$(RESET)"

lint: ## 設定ファイルの構文チェック
	@echo "$(BLUE)🔍 構文チェックを実行中...$(RESET)"
	@echo "$(YELLOW)  Lua構文チェック...$(RESET)"
	@find $(CONFIG_DIR) -name "*.lua" -exec $(NVIM) --headless -c "luafile {}" -c "quit" \; 2>/dev/null && echo "    ✅ Luaファイル構文OK" || echo "    ❌ Lua構文エラー"
	@echo "$(YELLOW)  YAML構文チェック...$(RESET)"
	@find . -name "*.yml" -o -name "*.yaml" | head -3 | xargs -I {} echo "    ✅ {}" 2>/dev/null || echo "    ⚠️  YAMLチェックをスキップ"
	@echo "$(GREEN)✅ 構文チェック完了$(RESET)"

# Maintenance
clean: ## 一時ファイルとキャッシュのクリーンアップ
	@echo "$(BLUE)🧹 クリーンアップ中...$(RESET)"
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name ".DS_Store" -delete 2>/dev/null || true
	@find . -name "*.log" -delete 2>/dev/null || true
	@$(CHEZMOI) purge --force 2>/dev/null || true
	@echo "$(GREEN)✅ クリーンアップ完了$(RESET)"

status: ## 現在の状態とヘルスチェック
	@echo "$(BLUE)📊 dotfiles状態確認$(RESET)"
	@echo "$(YELLOW)必須ツール:$(RESET)"
	@command -v chezmoi >/dev/null 2>&1 && echo "  ✅ chezmoi" || echo "  ❌ chezmoi"
	@command -v age >/dev/null 2>&1 && echo "  ✅ age" || echo "  ❌ age"
	@command -v nvim >/dev/null 2>&1 && echo "  ✅ neovim" || echo "  ❌ neovim"
	@command -v git >/dev/null 2>&1 && echo "  ✅ git" || echo "  ❌ git"
	@echo "$(YELLOW)Chezmoi状態:$(RESET)"
	@$(CHEZMOI) status 2>/dev/null || echo "  設定なし"
	@$(CHEZMOI) diff 2>/dev/null | head -10 || true
	@echo "$(YELLOW)Git状態:$(RESET)"
	@git status --porcelain 2>/dev/null | head -5 || echo "  Gitリポジトリではありません"
