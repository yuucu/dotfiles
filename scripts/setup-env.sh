#!/bin/bash

# Environment setup script for dotfiles
# Run this after cloning to set up personal environment variables

set -e

echo "🔧 Setting up environment variables..."

# Create .zshrc.local if it doesn't exist
if [[ ! -f "$HOME/.zshrc.local" ]]; then
    echo "📁 Creating ~/.zshrc.local for personal environment variables"
    
    cat > "$HOME/.zshrc.local" << 'EOF'
# Personal environment variables and secrets
# This file is not tracked by git and contains sensitive information

# API Tokens (replace with your actual tokens)
# export ZENPAY_REPO_PAT="your_github_token_here"
# export NPM_AUTH_TOKEN="your_npm_token_here"
# export OPENAI_API_KEY="your_openai_key_here"
# export ANTHROPIC_API_KEY="your_anthropic_key_here"

# Database connection aliases (uncomment and add passwords)
# alias common="mysql -h zenpay-dev-common.cluster-ctwuc4yaoe5i.ap-northeast-1.rds.amazonaws.com -u root -p"
# alias dev12="mysql -h develop12-sekai-zenpay-common.cluster-cfstvgy9uyc0.ap-northeast-1.rds.amazonaws.com -u viewer -p"

# Work configurations
export WORK_EMAIL="higuchi_yuya@applibot.co.jp"
export PERSONAL_EMAIL="yuucu.work@gmail.com"

# Git configuration shortcuts
alias work-git='git config --global user.name "higuchi-yuya-ab" && git config --global user.email "$WORK_EMAIL"'
alias personal-git='git config --global user.name "yuucu" && git config --global user.email "$PERSONAL_EMAIL"'
EOF

    echo "✅ Created ~/.zshrc.local template"
    echo "📝 Edit ~/.zshrc.local to add your actual API tokens and passwords"
else
    echo "✅ ~/.zshrc.local already exists"
fi

# Create .env template for project-specific variables
if [[ ! -f "$HOME/.env.template" ]]; then
    echo "📄 Creating ~/.env.template for project environment variables"
    
    cat > "$HOME/.env.template" << 'EOF'
# Project-specific environment variables template
# Copy this to .env in your project directory and customize

# Development
NODE_ENV=development
DEBUG=true
LOG_LEVEL=debug

# API Keys (replace with actual values)
API_KEY=your_api_key_here
SECRET_KEY=your_secret_key_here

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# External Services
REDIS_URL=redis://localhost:6379
ELASTICSEARCH_URL=http://localhost:9200
EOF

    echo "✅ Created ~/.env.template"
fi

echo ""
echo "🎉 Environment setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit ~/.zshrc.local to add your actual API tokens"
echo "2. Use ~/.env.template for project-specific environment variables"
echo "3. Never commit .env or .zshrc.local files to git"
echo ""
echo "🔒 Security tips:"
echo "- Use different tokens for development and production"
echo "- Rotate API tokens regularly"
echo "- Consider using a password manager for token storage" 