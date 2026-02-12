# React/Next.js/Hono/Fastify 開発環境セットアップ

このガイドでは、Neovim で React/Next.js/Hono/Fastify 開発を行うための環境を整えます。

## 必要なツールのインストール

### 1. Node.js ツール

```bash
# TypeScript と Language Server
npm install -g typescript typescript-language-server

# Oxc (Oxlint + Oxfmt)
npm install -g oxlint

# または Cargo でインストール
cargo install oxc
```

### 2. Oxc Language Server（オプション）

Oxc の LSP サポートは現在開発中です。代わりに以下のアプローチを使用：

**オプション A: Oxlint を Null-ls/None-ls で統合**

```bash
npm install -g @oxc-project/oxlint
```

**オプション B: Oxlint を直接実行**

```bash
# プロジェクトごとにインストール
npm install -D oxlint
```

## Neovim プラグイン設定

### 追加されたプラグイン

#### 1. **Tailwind Tools** (`tailwind.lua`)

- Tailwind CSS のクラス名補完
- 色のインラインプレビュー
- クラス名の並び替え

**有効化条件**: `tailwind.config.js` があるプロジェクト

#### 2. **TypeScript Tools** (`typescript-tools.lua`)

- TypeScript の高速化
- JSX/TSX の自動補完強化
- React Hooks のサポート
- 閉じタグの自動補完

**有効化条件**: `.ts`, `.tsx`, `.js`, `.jsx` ファイル

#### 3. **Colorizer** (`tailwind.lua`)

- CSS カラーコードの視覚化
- Tailwind カラークラスの色表示
- RGB, HSL, HEX サポート

#### 4. **Oxc LSP** (`lsp/oxc_lsp.lua`)

- Oxlint によるリアルタイム Lint
- Oxfmt による自動フォーマット

**注意**: 現在 Oxc の公式 LSP は開発中のため、この設定はプレースホルダーです

## プロジェクト設定

### Next.js プロジェクト

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "jsx": "preserve",
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "allowJs": true,
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
```

### Oxlint 設定

```json
// .oxlintrc.json
{
  "rules": {
    "react": "warn",
    "react-hooks": "error",
    "typescript": "warn",
    "unicorn": "warn"
  },
  "env": {
    "browser": true,
    "node": true,
    "es2021": true
  }
}
```

### Hono プロジェクト

```typescript
// tsconfig.json (Hono/Fastify バックエンド)
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "lib": ["ES2022"],
    "types": ["@cloudflare/workers-types"], // Cloudflare Workers の場合
    "jsx": "react-jsx", // JSX を使う場合
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true
  }
}
```

## 使い方

### Tailwind CSS

1. **クラス名補完**:
   - `className="` と入力すると自動的に Tailwind クラスが補完される
   - `bg-` と入力すると背景色の候補が表示される

2. **色のプレビュー**:
   - `bg-blue-500` などのクラス名の横に色が表示される
   - `#ff0000` などのカラーコードにも対応

### TypeScript/React

1. **コンポーネント補完**:
   - `<Button` と入力すると props の型情報が表示される
   - `useState` などの Hooks も補完される

2. **自動 import**:
   - コンポーネントを入力すると自動的に import 文が追加される
   - `gd` で定義元にジャンプ

3. **型情報の表示**:
   - `K` (LSP Saga の hover) で型情報を表示
   - Inlay Hints で関数の引数名や型が表示される

### Oxlint

1. **リアルタイム Lint**:
   - ファイルを編集すると自動的に Oxlint が実行される
   - エラーは診断ウィンドウに表示

2. **手動実行**:
   ```bash
   oxlint --fix
   ```

3. **保存時フォーマット**:
   - Oxfmt が自動的に実行される（設定済み）

## プロジェクト構成例

### Next.js App Router

```
my-nextjs-app/
├── src/
│   ├── app/
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── api/
│   ├── components/
│   ├── lib/
│   └── types/
├── public/
├── tailwind.config.js
├── tsconfig.json
├── .oxlintrc.json
└── package.json
```

### Hono API

```
my-hono-api/
├── src/
│   ├── index.ts
│   ├── routes/
│   ├── middleware/
│   └── types/
├── tsconfig.json
├── .oxlintrc.json
└── package.json
```

## トラブルシューティング

### TypeScript Language Server が起動しない

1. LSP ログを確認:
   ```vim
   :LspInfo
   :LspLog
   ```

2. TypeScript のバージョン確認:
   ```bash
   npm list -g typescript
   ```

### Tailwind の補完が出ない

1. `tailwind.config.js` があるか確認
2. Neovim を再起動
3. `:Lazy sync` でプラグインを更新

### Oxlint が動作しない

1. Oxlint のインストール確認:
   ```bash
   which oxlint
   oxlint --version
   ```

2. `.oxlintrc.json` を作成

## パフォーマンス最適化

### 大規模プロジェクト

1. **TypeScript の除外設定**:
   ```json
   // tsconfig.json
   {
     "exclude": ["node_modules", "dist", ".next", "out"]
   }
   ```

2. **BigFile プラグイン**:
   - 2MB 以上のファイルで LSP が自動的に無効化される（設定済み）

3. **Incremental Build**:
   ```json
   {
     "compilerOptions": {
       "incremental": true,
       "tsBuildInfoFile": ".tsbuildinfo"
     }
   }
   ```

## 参考リンク

- [TypeScript Tools](https://github.com/pmizio/typescript-tools.nvim)
- [Tailwind Tools](https://github.com/luckasRanarison/tailwind-tools.nvim)
- [Oxc Project](https://oxc-project.github.io/)
- [Next.js Docs](https://nextjs.org/docs)
- [Hono Docs](https://hono.dev/)
- [Fastify Docs](https://www.fastify.io/)
