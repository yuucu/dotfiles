local M = {}

-- LSP capabilities の設定
M.capabilities = function()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- snippet サポートを明示的に有効化
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' },
  }
  return capabilities
end

-- on_attach 共通設定
M.on_attach = function(client, bufnr)
  require('lsp-format').on_attach(client, bufnr)

  -- セマンティックトークンを有効化
  if client.server_capabilities.semanticTokensProvider then
    vim.api.nvim_set_hl(0, '@lsp.type.namespace', { link = '@namespace' })
    vim.api.nvim_set_hl(0, '@lsp.type.type', { link = '@type' })
    vim.api.nvim_set_hl(0, '@lsp.type.class', { link = '@class' })
    vim.api.nvim_set_hl(0, '@lsp.type.enum', { link = '@type' })
    vim.api.nvim_set_hl(0, '@lsp.type.interface', { link = '@interface' })
    vim.api.nvim_set_hl(0, '@lsp.type.struct', { link = '@structure' })
    vim.api.nvim_set_hl(0, '@lsp.type.parameter', { link = '@parameter' })
    vim.api.nvim_set_hl(0, '@lsp.type.variable', { link = '@variable' })
    vim.api.nvim_set_hl(0, '@lsp.type.property', { link = '@property' })
    vim.api.nvim_set_hl(0, '@lsp.type.enumMember', { link = '@constant' })
    vim.api.nvim_set_hl(0, '@lsp.type.function', { link = '@function' })
    vim.api.nvim_set_hl(0, '@lsp.type.method', { link = '@method' })
    vim.api.nvim_set_hl(0, '@lsp.type.macro', { link = '@macro' })
    vim.api.nvim_set_hl(0, '@lsp.type.decorator', { link = '@function' })
  end
end

-- 診断設定
M.setup_diagnostics = function()
  vim.diagnostic.config({
    virtual_text = {
      spacing = 4,
      source = 'if_many',
      prefix = '●',
      severity = { min = vim.diagnostic.severity.HINT },
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
      focusable = false,
    },
  })

  -- 診断記号の設定
  local signs = {
    { name = 'DiagnosticSignError', text = '' },
    { name = 'DiagnosticSignWarn', text = '' },
    { name = 'DiagnosticSignHint', text = '' },
    { name = 'DiagnosticSignInfo', text = '' },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
  end

  -- ホバーウィンドウとシグネチャヘルプのボーダー設定
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  vim.lsp.handlers['textDocument/signatureHelp'] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
end

-- LSP キーマップ設定
M.setup_keymaps = function()
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local opts = { buffer = ev.buf }
      local maps = {
        gD = vim.lsp.buf.declaration,
        gd = vim.lsp.buf.definition,
        gi = vim.lsp.buf.implementation,
        ['<C-k>'] = vim.lsp.buf.signature_help,
        ['<space>D'] = vim.lsp.buf.type_definition,
        ['<space>rn'] = vim.lsp.buf.rename,
        gr = vim.lsp.buf.references,
      }
      for key, func in pairs(maps) do
        vim.keymap.set('n', key, func, opts)
      end
    end,
  })
end

return M
