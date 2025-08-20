# PlantUML LSP インストールガイド

## 1. plantuml-lsp のインストール

### Go を使ったインストール（推奨）
```bash
go install github.com/ptdewey/plantuml-lsp@latest
```

### ソースからのインストール
```bash
git clone https://github.com/ptdewey/plantuml-lsp.git
cd plantuml-lsp
go build
# バイナリを適切なPATHに移動
sudo mv plantuml-lsp /usr/local/bin/
```

## 2. PlantUML の準備

PlantUMLがインストールされていない場合：

### macOS（Homebrew）
```bash
brew install plantuml
```

### その他の方法
```bash
# PlantUMLのjarファイルをダウンロード
# または適切なパッケージマネージャーでインストール
```

## 3. 設定の適用

```bash
# dotfilesの変更を適用
chezmoi apply
```

## 4. 動作確認

1. Neovimを再起動
2. `.puml` または `.plantuml` ファイルを開く
3. LSPが起動していることを確認：`:LspInfo`

## ファイルタイプ対応

以下の拡張子でPlantUML LSPが動作します：
- `.puml`
- `.plantuml` 
- `.pu`
- `.uml`