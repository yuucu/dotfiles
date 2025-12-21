return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'lukas-reineke/lsp-format.nvim',
    'folke/neodev.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    -- LSP capabilities の設定
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    -- snippet サポートを明示的に有効化
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = { 'documentation', 'detail', 'additionalTextEdits' },
    }

    local on_attach = function(client, bufnr)
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

    -- 診断設定の強化
    vim.diagnostic.config({
      virtual_text = {
        spacing = 4,
        source = 'if_many',
        prefix = '●',
        -- severity による表示制御
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

    -- Go自動フォーマット
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.go',
      callback = function()
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
        vim.lsp.buf.format({ async = false })
      end,
    })

    -- TypeScript/React自動フォーマット
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
      callback = function()
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
        vim.lsp.buf.format({ async = false })
      end,
    })

    require('neodev').setup()

    -- 新しい vim.lsp.config API を使用
    -- TypeScript (ts_ls)
    vim.lsp.config('ts_ls', {
      cmd = { 'typescript-language-server', '--stdio' },
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
      },
      root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json' },
      single_file_support = true,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = 'literals',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = false, -- パフォーマンス重視でデフォルト無効
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          suggest = {
            includeCompletionsForModuleExports = true,
          },
          format = {
            enable = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = 'literals',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          suggest = {
            includeCompletionsForModuleExports = true,
          },
          format = {
            enable = true,
          },
        },
      },
      capabilities = capabilities,
      on_attach = on_attach,
    })
    vim.lsp.enable('ts_ls')

    -- Deno
    vim.lsp.config('denols', {
      cmd = { 'deno', 'lsp' },
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
      },
      root_markers = { 'deno.json', 'deno.jsonc' },
      init_options = { lint = true, unstable = true },
      capabilities = capabilities,
      on_attach = on_attach,
    })
    vim.lsp.enable('denols')

    -- Lua
    vim.lsp.config('lua_ls', {
      cmd = { 'lua-language-server' },
      filetypes = { 'lua' },
      root_markers = {
        '.luarc.json',
        '.luarc.jsonc',
        '.luacheckrc',
        '.stylua.toml',
        'stylua.toml',
        'selene.toml',
        'selene.yml',
        '.git',
      },
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          diagnostics = {
            globals = { 'vim' },
            disable = { 'missing-fields' },
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              '${3rd}/luv/library',
            },
          },
          completion = {
            callSnippet = 'Replace',
          },
          telemetry = {
            enable = false,
          },
          hint = {
            enable = true,
            setType = false,
            paramType = true,
            paramName = 'Disable',
            semicolon = 'Disable',
            arrayIndex = 'Disable',
          },
        },
      },
      capabilities = capabilities,
      on_attach = on_attach,
    })
    vim.lsp.enable('lua_ls')

    -- Go
    vim.lsp.config('gopls', {
      cmd = { 'gopls' },
      filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
      root_markers = { 'go.work', 'go.mod', '.git' },
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
            shadow = true,
            nilness = true,
            unusedwrite = true,
          },
          staticcheck = true,
          gofumpt = true,
          semanticTokens = true,
          usePlaceholders = true,
          completeUnimported = true,
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
      capabilities = capabilities,
      on_attach = on_attach,
    })
    vim.lsp.enable('gopls')

    -- PlantUML
    vim.lsp.config('plantuml_lsp', {
      cmd = { 'plantuml-lsp' },
      filetypes = { 'plantuml', 'puml' },
      root_markers = { '.git' },
      capabilities = capabilities,
      on_attach = on_attach,
    })
    vim.lsp.enable('plantuml_lsp')

    -- Terraform
    vim.lsp.config('terraformls', {
      cmd = { 'terraform-ls', 'serve' },
      filetypes = { 'terraform', 'tf', 'hcl' },
      root_markers = { '.terraform', '.git' },
      capabilities = capabilities,
      on_attach = on_attach,
    })
    vim.lsp.enable('terraformls')

    -- LSPキーマップ
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
  end,
}
