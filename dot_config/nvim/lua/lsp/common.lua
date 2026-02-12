local M = {}
-- サーバー個別設定は `after/lsp/<server>.lua` で管理する
M.servers = { 'denols', 'oxc_lsp', 'lua_ls', 'gopls', 'plantuml_lsp', 'terraformls', 'yamlls', 'jsonls' }

local formatters_by_ft = {
  go = { 'gopls' },
  javascript = { 'oxc_lsp', 'typescript-tools', 'tsserver' },
  javascriptreact = { 'oxc_lsp', 'typescript-tools', 'tsserver' },
  typescript = { 'oxc_lsp', 'typescript-tools', 'tsserver' },
  typescriptreact = { 'oxc_lsp', 'typescript-tools', 'tsserver' },
}

local organize_imports_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

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
    virtual_text = false,
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
      max_width = 100,
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

local function preferred_formatter_id(bufnr)
  local ft = vim.bo[bufnr].filetype
  local preferred = formatters_by_ft[ft]
  if not preferred then
    return nil
  end

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, name in ipairs(preferred) do
    for _, client in ipairs(clients) do
      if client.name == name and client.supports_method and client:supports_method('textDocument/formatting') then
        return client.id
      end
    end
  end
  return nil
end

M.setup_format_on_save = function()
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('LspFormatOnSave', { clear = true }),
    callback = function(ev)
      local bufnr = ev.buf
      local ft = vim.bo[bufnr].filetype

      if organize_imports_filetypes[ft] then
        pcall(vim.lsp.buf.code_action, {
          context = { only = { 'source.organizeImports' } },
          apply = true,
        })
      end

      vim.lsp.buf.format({
        async = false,
        timeout_ms = 1000,
        bufnr = bufnr,
        id = preferred_formatter_id(bufnr),
      })
    end,
  })
end

M.setup = function()
  M.setup_diagnostics()
  M.setup_keymaps()
  M.setup_format_on_save()

  vim.lsp.config('*', {
    capabilities = M.capabilities(),
    on_attach = vim.schedule_wrap(M.on_attach),
  })

  for _, server in ipairs(M.servers) do
    vim.lsp.enable(server)
  end
end

-- lsp-lens 設定
M.lens_opts = function()
  return {
    sections = {
      git_authors = false,
      definition = function(count)
        return '󰳽 ' .. count
      end,
      references = function(count)
        return '󰈇 ' .. count
      end,
      implements = function(count)
        return '󰡱 ' .. count
      end,
    },
    separator = '  ',
    hide_zero_counts = true,
  }
end

return M
