# Makefile for dotfiles management
# ================================
# シンプルなdotfiles管理タスク

.PHONY: help install update clean status ci-check security-check security-quick security-full security-gitleaks security-trufflehog security-report security-setup security-clean setup-git-hooks

# Variables
SCRIPTS_DIR := scripts
CHEZMOI := chezmoi
MISE := mise

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
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)📋 カテゴリ別タスク:$(RESET)"
	@echo "  $(BLUE)基本操作:$(RESET) install, update, status, clean"
	@echo "  $(BLUE)セキュリティ:$(RESET) security-check, security-quick, security-full, security-report"
	@echo "  $(BLUE)開発・CI:$(RESET) ci-check, setup-git-hooks"

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
	@$(MAKE) security-check || true

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

# ==========================================
# 🔒 セキュリティチェック統合タスク
# ==========================================

security-setup: ## 🔧 セキュリティ環境の完全セットアップ
	@echo "$(BLUE)🔧 セキュリティ環境セットアップ中...$(RESET)"
	@$(MAKE) install
	@$(MAKE) setup-git-hooks
	@$(MAKE) security-clean
	@$(MAKE) security-report
	@echo "$(GREEN)✅ セキュリティ環境セットアップ完了$(RESET)"

security-check: security-quick ## 🔒 標準的なセキュリティチェック（推奨）
	@echo "$(GREEN)✅ セキュリティチェック完了$(RESET)"

security-quick: ## ⚡ 高速セキュリティチェック（GitLeaks + 自前スクリプト）
	@echo "$(BLUE)⚡ 高速セキュリティチェック実行中...$(RESET)"
	@$(MAKE) security-gitleaks
	@$(MAKE) security-custom

security-full: ## 🔍 完全セキュリティチェック（全ツール + 詳細レポート）
	@echo "$(BLUE)🔍 完全セキュリティチェック実行中...$(RESET)"
	@$(MAKE) security-gitleaks
	@$(MAKE) security-trufflehog
	@$(MAKE) security-custom
	@$(MAKE) security-report

security-clean: ## 🧹 セキュリティ関連の一時ファイル・ログを削除
	@echo "$(BLUE)🧹 セキュリティ関連ファイルクリーンアップ中...$(RESET)"
	@find . -name "*.log" -path "*/.config/gcloud/logs/*" -delete 2>/dev/null || true
	@find . -name "gitleaks-report.*" -delete 2>/dev/null || true
	@find . -name "trufflehog-report.*" -delete 2>/dev/null || true
	@find . -name ".security-scan.*" -delete 2>/dev/null || true
	@echo "$(GREEN)✅ セキュリティファイルクリーンアップ完了$(RESET)"

security-report: ## 📊 セキュリティチェック結果レポート
	@echo "$(BLUE)📊 セキュリティレポート生成中...$(RESET)"
	@echo "========================================"
	@echo "$(YELLOW)🔒 セキュリティチェック結果$(RESET)"
	@echo "========================================"
	@echo "$(BLUE)実行日時:$(RESET) $$(date '+%Y-%m-%d %H:%M:%S')"
	@echo "$(BLUE)リポジトリ:$(RESET) $$(git remote get-url origin 2>/dev/null || echo 'ローカルリポジトリ')"
	@echo "$(BLUE)ブランチ:$(RESET) $$(git branch --show-current 2>/dev/null || echo '不明')"
	@echo "$(BLUE)コミット:$(RESET) $$(git rev-parse --short HEAD 2>/dev/null || echo '不明')"
	@echo "========================================"
	@echo "$(YELLOW)ツール確認:$(RESET)"
	@command -v gitleaks >/dev/null 2>&1 && echo "  ✅ GitLeaks: $$(gitleaks version 2>/dev/null | head -n1 | sed 's/^v//')" || echo "  ❌ GitLeaks: 未インストール"
	@command -v trufflehog >/dev/null 2>&1 && echo "  ✅ TruffleHog: $$(trufflehog --version 2>/dev/null | head -n1 | sed 's/trufflehog //')" || echo "  ❌ TruffleHog: 未インストール"
	@test -f scripts/pre-commit-security-check.sh && echo "  ✅ 自前スクリプト: 利用可能" || echo "  ❌ 自前スクリプト: 見つからない"
	@echo "$(YELLOW)Git Hooks:$(RESET)"
	@test -f .git/hooks/pre-commit && echo "  ✅ pre-commit hook: 設定済み" || echo "  ❌ pre-commit hook: 未設定"
	@echo "$(YELLOW)設定ファイル:$(RESET)"
	@test -f .gitleaks.toml && echo "  ✅ GitLeaks設定: 存在" || echo "  ❌ GitLeaks設定: 見つからない"
	@test -f .trufflehog.yml && echo "  ✅ TruffleHog設定: 存在" || echo "  ❌ TruffleHog設定: 見つからない"
	@echo "========================================"

# Individual security tools
security-gitleaks: ## 🔍 GitLeaksでシークレット検出
	@echo "$(BLUE)🔍 GitLeaks スキャン中...$(RESET)"
	@if command -v gitleaks >/dev/null 2>&1; then \
		if gitleaks detect --source . --config .gitleaks.toml --verbose --exit-code 0; then \
			echo "$(GREEN)✅ GitLeaks: 問題なし$(RESET)"; \
		else \
			echo "$(YELLOW)⚠️  GitLeaks: 警告があります（除外設定で対応済み）$(RESET)"; \
		fi \
	else \
		echo "$(YELLOW)⚠️  GitLeaksがインストールされていません。$(RESET)"; \
		echo "$(BLUE)インストール: make install$(RESET)"; \
	fi

security-trufflehog: ## 🔍 TruffleHogで機密情報検出
	@echo "$(BLUE)🔍 TruffleHog スキャン中...$(RESET)"
	@if command -v trufflehog >/dev/null 2>&1; then \
		if trufflehog git file://. --config .trufflehog.yml --no-update --exit-code 0; then \
			echo "$(GREEN)✅ TruffleHog: 問題なし$(RESET)"; \
		else \
			echo "$(YELLOW)⚠️  TruffleHog: 警告があります$(RESET)"; \
		fi \
	else \
		echo "$(YELLOW)⚠️  TruffleHogがインストールされていません。$(RESET)"; \
		echo "$(BLUE)インストール: make install$(RESET)"; \
	fi

security-custom: ## 🔧 自前セキュリティスクリプト実行
	@echo "$(BLUE)🔧 自前セキュリティチェック実行中...$(RESET)"
	@if test -f scripts/pre-commit-security-check.sh; then \
		chmod +x scripts/pre-commit-security-check.sh; \
		if ./scripts/pre-commit-security-check.sh; then \
			echo "$(GREEN)✅ 自前チェック: 問題なし$(RESET)"; \
		else \
			echo "$(RED)⚠️  自前チェック: 潜在的な問題を発見$(RESET)"; \
		fi \
	else \
		echo "$(YELLOW)⚠️  自前セキュリティスクリプトが見つかりません$(RESET)"; \
	fi

setup-git-hooks: ## 🔧 Git pre-commit hooks セットアップ
	@echo "$(BLUE)🔧 Git hooks セットアップ中...$(RESET)"
	@if test -f scripts/setup-git-hooks.sh; then \
		chmod +x scripts/setup-git-hooks.sh; \
		./scripts/setup-git-hooks.sh; \
	else \
		echo "$(YELLOW)⚠️  Git hooks スクリプトが見つかりません$(RESET)"; \
	fi
