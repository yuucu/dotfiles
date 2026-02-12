return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'lukas-reineke/lsp-format.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local common = require('lsp.common')

    -- 診断設定
    common.setup_diagnostics()

    -- LSP キーマップ設定
    common.setup_keymaps()

    -- 全サーバー共通設定（Neovim 0.10+ の新しい API）
    vim.lsp.config('*', {
      capabilities = common.capabilities(),
      on_attach = vim.schedule_wrap(common.on_attach), -- 非同期実行で起動時間短縮
    })

    -- 自動フォーマット（Go, TypeScript, JavaScript）
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = { '*.go', '*.ts', '*.tsx', '*.js', '*.jsx' },
      group = vim.api.nvim_create_augroup('LspFormatOnSave', { clear = true }),
      callback = function()
        -- organize imports を実行
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
        -- 非同期フォーマット（UI ブロックを回避）
        vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
      end,
    })

    -- LSP サーバーを有効化（設定は lsp/*.lua から自動マージされる）
    local servers = { 'ts_ls', 'denols', 'lua_ls', 'gopls', 'plantuml_lsp', 'terraformls' }
    for _, server in ipairs(servers) do
      vim.lsp.enable(server)
    end
  end,
}
