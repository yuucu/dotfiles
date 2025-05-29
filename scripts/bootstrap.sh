#!/bin/bash
set -euo pipefail

# dotfiles 初期化スクリプト
echo "🚀 dotfiles初期化を開始します..."

# 必要なツールのインストール確認
command -v chezmoi >/dev/null 2>&1 || {
    echo "chezmoiをインストールしています..."
    sh -c "$(curl -fsLS get.chezmoi.io)"
}

command -v age >/dev/null 2>&1 || {
    echo "ageをインストールしています..."
    if command -v brew >/dev/null 2>&1; then
        brew install age
    elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y age
    else
        echo "❌ パッケージマネージャーが見つかりません。手動でageをインストールしてください。"
        exit 1
    fi
}

# Neovim最新版のチェック
if command -v nvim >/dev/null 2>&1; then
    nvim_version=$(nvim --version | head -n1 | sed 's/NVIM v//')
    echo "✅ Neovim ${nvim_version} が見つかりました"
else
    echo "⚠️  Neovimが見つかりません。手動でインストールしてください。"
fi

echo "✅ dotfiles初期化が完了しました！"
echo "📝 暗号化されたファイルがある場合は、AGE_SECRET_KEYを設定してください。" 