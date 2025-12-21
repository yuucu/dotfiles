return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'lukas-reineke/lsp-format.nvim',
    'folke/neodev.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local common = require('lsp.common')

    -- neodev を先に setup
    require('neodev').setup()

    -- 診断設定
    common.setup_diagnostics()

    -- LSP キーマップ設定
    common.setup_keymaps()

    -- 全サーバー共通設定
    vim.lsp.config('*', {
      capabilities = common.capabilities(),
      on_attach = common.on_attach,
    })

    -- Go 自動フォーマット
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.go',
      callback = function()
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
        vim.lsp.buf.format({ async = false })
      end,
    })

    -- TypeScript/React 自動フォーマット
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
      callback = function()
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
        vim.lsp.buf.format({ async = false })
      end,
    })

    -- LSP サーバーを有効化（設定は lsp/*.lua から自動マージされる）
    local servers = { 'ts_ls', 'denols', 'lua_ls', 'gopls', 'plantuml_lsp', 'terraformls' }
    for _, server in ipairs(servers) do
      vim.lsp.enable(server)
    end
  end,
}
