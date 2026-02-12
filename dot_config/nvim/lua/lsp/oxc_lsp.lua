-- Oxc Language Server (Oxlint の LSP)
-- npm install -g oxc-language-server でインストール必要
return {
  -- package.json があるプロジェクトで有効化
  root_dir = require('lspconfig.util').root_pattern('package.json', '.oxlintrc.json'),

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

  on_attach = function(client, bufnr)
    -- Oxfmt による自動フォーマット
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
      end,
    })
  end,
}
