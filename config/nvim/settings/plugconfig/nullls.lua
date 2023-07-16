local null_ls = require('null-ls')
local sources = {
  null_ls.builtins.diagnostics.cspell.with({
    diagnostics_postprocess = function(diagnostic)
      -- レベルをWARNに変更（デフォルトはERROR）
      diagnostic.severity = vim.diagnostic.severity["WARN"]
    end,
    condition = function()
      -- cspellが実行できるときのみ有効
      return vim.fn.executable('cspell') > 0
    end,
    -- 起動時に設定ファイル読み込み
    extra_args = { '--config', '~/.config/cspell/cspell.json' }
  })
}

null_ls.setup({
  sources = sources
})
