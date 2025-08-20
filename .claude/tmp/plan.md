# PlantUML LSP導入計画

## 実装手順

### 1. 現在のvim設定確認 ✅
- [x] vimの設定ファイル構造を確認
- [x] プラグイン管理方法（lazy.nvim）を特定
- [x] LSP設定の現状を確認

### 2. PlantUML LSP調査 ✅
- [x] 利用可能なPlantUML LSPサーバーを調査
- [x] 推奨されるLSPサーバー（ptdewey/plantuml-lsp）を選択
- [x] インストール方法を確認

### 3. vim設定への追加 ✅
- [x] LSPクライアントの設定
- [x] PlantUMLファイルタイプの関連付け
- [x] 必要な設定の追加

### 4. 動作確認 ✅
- [x] 設定の適用（chezmoi apply）
- [x] 設定ファイルの変更をコミット
- [x] インストールガイドの作成

## 完了

PlantUML LSPの設定が完了いたしました。

### 次に必要な作業
1. `go install github.com/ptdewey/plantuml-lsp@latest` でLSPサーバーをインストール
2. PlantUMLがインストールされていない場合は `brew install plantuml`
3. Neovimを再起動して動作確認