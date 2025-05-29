# Makefile for Neovim Lua configuration
# =================================

.PHONY: test lint help clean

# Variables
NVIM := nvim
CONFIG_DIR := .config/nvim

# Default target
help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

# Test target
test: ## Run Lua tests
	@echo "🧪 Running Lua tests..."
	@$(NVIM) --headless -c "lua require('utils.notes_test').run_all_tests()" -c "quit"
	@echo "✅ Tests completed"

# Lint target
lint: ## Check Lua syntax
	@echo "🔍 Checking Lua syntax..."
	@find $(CONFIG_DIR) -name "*.lua" -exec $(NVIM) --headless -c "luafile {}" -c "quit" \; 2>/dev/null && echo "✅ All Lua files have valid syntax" || echo "❌ Syntax errors found"

# Clean target
clean: ## Clean temporary files
	@echo "🧹 Cleaning temporary files..."
	@find $(CONFIG_DIR) -name "*.tmp" -delete 2>/dev/null || true
	@find $(CONFIG_DIR) -name ".DS_Store" -delete 2>/dev/null || true
	@echo "✅ Cleanup completed"
