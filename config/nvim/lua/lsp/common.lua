local M = {}
-- サーバー個別設定は `after/lsp/<server>.lua` で管理する
-- バイナリは nix（home/default.nix の home.packages）で提供する
M.servers = {
  'denols',
  'lua_ls',
  'gopls',
  'terraformls',
  'yamlls',
  'jsonls',
  'eslint',
  'prismals',
  'gdscript',
}

local formatters_by_ft = {
  go = { 'gopls' },
  javascript = { 'typescript-tools', 'tsserver' },
  javascriptreact = { 'typescript-tools', 'tsserver' },
  typescript = { 'typescript-tools', 'tsserver' },
  typescriptreact = { 'typescript-tools', 'tsserver' },
}

local organize_imports_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

local float_border = 'rounded'

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

-- セマンティックトークンのハイライトを treesitter のグループへリンク
M.setup_semantic_highlights = function()
  local links = {
    ['@lsp.type.namespace'] = '@namespace',
    ['@lsp.type.type'] = '@type',
    ['@lsp.type.class'] = '@class',
    ['@lsp.type.enum'] = '@type',
    ['@lsp.type.interface'] = '@interface',
    ['@lsp.type.struct'] = '@structure',
    ['@lsp.type.parameter'] = '@parameter',
    ['@lsp.type.variable'] = '@variable',
    ['@lsp.type.property'] = '@property',
    ['@lsp.type.enumMember'] = '@constant',
    ['@lsp.type.function'] = '@function',
    ['@lsp.type.method'] = '@method',
    ['@lsp.type.macro'] = '@macro',
    ['@lsp.type.decorator'] = '@function',
  }
  for group, link in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = link })
  end
end

-- 診断設定
M.setup_diagnostics = function()
  vim.diagnostic.config({
    virtual_text = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.HINT] = '',
        [vim.diagnostic.severity.INFO] = '',
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = float_border,
      source = true,
      header = '',
      prefix = '',
      focusable = false,
      max_width = 100,
    },
  })
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
        K = function()
          vim.lsp.buf.hover({ border = float_border, max_width = 100 })
        end,
        ['<C-k>'] = function()
          vim.lsp.buf.signature_help({ border = float_border })
        end,
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
      if client.name == name and client:supports_method('textDocument/formatting') then
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

      -- フォーマット可能な LSP がいないバッファでは何もしない（警告メッセージ抑止）
      local can_format = false
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        if client:supports_method('textDocument/formatting') then
          can_format = true
          break
        end
      end
      if not can_format then
        return
      end

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
  M.setup_semantic_highlights()
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('LspSemanticHighlights', { clear = true }),
    callback = M.setup_semantic_highlights,
  })
  M.setup_keymaps()
  M.setup_format_on_save()

  vim.lsp.config('*', {
    capabilities = M.capabilities(),
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
