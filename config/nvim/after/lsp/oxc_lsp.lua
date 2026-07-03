-- Oxc Language Server (Oxlint の LSP)
-- npm install -g oxc-language-server でインストール必要
return {
  -- package.json があるプロジェクトで有効化
  root_markers = { 'package.json', '.oxlintrc.json' },

  settings = {
    oxc = {
      enable = true,
      -- Oxlint のルール設定
      rules = {
        -- デフォルトで推奨ルールを有効化
        recommended = true,
      },
      -- フォーマッター設定（oxfmt 使用）
      format = {
        enabled = true,
      },
    },
  },
}
