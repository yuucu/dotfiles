# Makefile for dotfiles management
# ================================
# シンプルなdotfiles管理タスク

.PHONY: help install update clean status ci-check security-check setup-git-hooks security-check-gitleaks security-check-trufflehog security-check-all

# Variables
SCRIPTS_DIR := scripts
CHEZMOI := chezmoi
MISE := mise

# Colors for output
GREEN := \033[32m
BLUE := \033[34m
YELLOW := \033[33m
RESET := \033[0m

# Default target
help: ## このヘルプメッセージを表示
	@echo "$(BLUE)dotfiles管理用Makefile$(RESET)"
	@echo "================================"
	@echo "利用可能なタスク:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2}'

# Core commands
install: ## 🚀 必要なツール、セキュリティツール、Git hooks を全てインストール
	@chmod +x $(SCRIPTS_DIR)/install.sh
	@$(SCRIPTS_DIR)/install.sh

update: ## 📦 dotfiles、プラグイン、miseツールの更新
	@chmod +x $(SCRIPTS_DIR)/update.sh
	@$(SCRIPTS_DIR)/update.sh

# Development
ci-check: ## 🔍 CIでチェックされる項目をローカルで確認（セキュリティチェック含む）
	@chmod +x $(SCRIPTS_DIR)/ci-check.sh
	@$(SCRIPTS_DIR)/ci-check.sh
	@echo "$(BLUE)🔒 セキュリティチェック実行中...$(RESET)"
	@$(MAKE) security-check-all || true

# Maintenance
clean: ## 🧹 一時ファイルとキャッシュのクリーンアップ
	@echo "$(BLUE)🧹 クリーンアップ中...$(RESET)"
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name ".DS_Store" -delete 2>/dev/null || true
	@find . -name "*.log" -delete 2>/dev/null || true
	@$(CHEZMOI) purge --force 2>/dev/null || true
	@echo "$(GREEN)✅ クリーンアップ完了$(RESET)"

status: ## 📊 現在の状態とヘルスチェック
	@echo "$(BLUE)📊 dotfiles状態確認$(RESET)"
	@echo "$(YELLOW)必須ツール:$(RESET)"
	@command -v chezmoi >/dev/null 2>&1 && echo "  ✅ chezmoi" || echo "  ❌ chezmoi"
	@command -v age >/dev/null 2>&1 && echo "  ✅ age" || echo "  ❌ age"
	@command -v nvim >/dev/null 2>&1 && echo "  ✅ neovim" || echo "  ❌ neovim"
	@command -v mise >/dev/null 2>&1 && echo "  ✅ mise" || echo "  ❌ mise"
	@echo "$(YELLOW)セキュリティツール:$(RESET)"
	@command -v gitleaks >/dev/null 2>&1 && echo "  ✅ gitleaks" || echo "  ❌ gitleaks"
	@command -v trufflehog >/dev/null 2>&1 && echo "  ✅ trufflehog" || echo "  ❌ trufflehog"
	@echo "$(YELLOW)mise管理ツール:$(RESET)"
	@$(MISE) current 2>/dev/null || echo "  miseが設定されていません"
	@echo "$(YELLOW)Chezmoi状態:$(RESET)"
	@$(CHEZMOI) status 2>/dev/null || echo "  設定なし"

# Security commands
security-check: ## 🔒 自前スクリプトで機密情報チェックを実行
	@./scripts/pre-commit-security-check.sh

setup-git-hooks: ## 🔧 Git pre-commit hooks をセットアップ
	@./scripts/setup-git-hooks.sh

security-check-gitleaks: ## 🔍 GitLeaksでセキュリティチェック
	@echo "$(BLUE)🔍 GitLeaks でスキャン中...$(RESET)"
	@if command -v gitleaks >/dev/null 2>&1; then \
		gitleaks detect --source . --config .gitleaks.toml --verbose; \
	else \
		echo "$(YELLOW)⚠️  GitLeaksがインストールされていません。make install を実行してください。$(RESET)"; \
	fi

security-check-trufflehog: ## 🔍 TruffleHogでセキュリティチェック
	@echo "$(BLUE)🔍 TruffleHog でスキャン中...$(RESET)"
	@if command -v trufflehog >/dev/null 2>&1; then \
		trufflehog git file://. --config .trufflehog.yml; \
	else \
		echo "$(YELLOW)⚠️  TruffleHogがインストールされていません。make install を実行してください。$(RESET)"; \
	fi

security-check-all: security-check-gitleaks security-check-trufflehog ## 🔒 全セキュリティツールでチェック
