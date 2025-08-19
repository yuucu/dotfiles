return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'lukas-reineke/lsp-format.nvim',
    'folke/neodev.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local on_attach = function(client, bufnr)
      require('lsp-format').on_attach(client, bufnr)
    end

    -- 診断設定
    vim.diagnostic.config({ virtual_text = true, signs = true, float = true })

    -- Go自動フォーマット
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.go',
      callback = function()
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
        vim.lsp.buf.format({ async = false })
      end,
    })

    -- PlantUML LSPサーバー設定
    local configs = require('lspconfig.configs')
    if not configs.plantuml_lsp then
      configs.plantuml_lsp = {
        default_config = {
          cmd = { 'plantuml-lsp' },
          filetypes = { 'plantuml', 'puml' },
          root_dir = function(fname)
            return lspconfig.util.find_git_ancestor(fname) or lspconfig.util.path.dirname(fname)
          end,
          settings = {},
        },
      }
    end

    -- LSPサーバー設定
    local servers = {
      ts_ls = { single_file_support = false, root_dir = lspconfig.util.root_pattern('package.json') },
      denols = { 
        root_dir = lspconfig.util.root_pattern('deno.json'),
        init_options = { lint = true, unstable = true }
      },
      lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
      gopls = {},
      plantuml_lsp = {},
    }

    require('neodev').setup()
    
    for server, config in pairs(servers) do
      config.capabilities = capabilities
      config.on_attach = on_attach
      lspconfig[server].setup(config)
    end

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
