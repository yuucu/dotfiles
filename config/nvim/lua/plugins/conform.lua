-- フォーマッター（保存時フォーマット）
-- 外部フォーマッターがある filetype はそれを使い、ない場合は LSP の整形にフォールバックする。
-- prettier / biome はプロジェクトの node_modules/.bin を優先して使う。
local js_formatters = { 'biome', 'prettier', stop_after_first = true }

return {
  'stevearc/conform.nvim',
  version = 'v9.1.0',
  event = 'BufWritePre',
  cmd = 'ConformInfo',
  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = js_formatters,
      javascriptreact = js_formatters,
      typescript = js_formatters,
      typescriptreact = js_formatters,
      json = js_formatters,
      jsonc = js_formatters,
    },
    formatters = {
      -- 設定ファイルがあるプロジェクトでのみ使う（ないプロジェクトでは LSP の整形にフォールバック）
      biome = { require_cwd = true },
      prettier = { require_cwd = true },
    },
    default_format_opts = { lsp_format = 'fallback' },
    format_on_save = function(bufnr)
      return require('lsp.common').format_on_save_opts(bufnr)
    end,
  },
}
