return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'lukas-reineke/lsp-format.nvim',
    'folke/neodev.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
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

    require('neodev').setup()

    -- 新しい vim.lsp.config API を使用
    -- TypeScript (ts_ls)
    vim.lsp.config('ts_ls', {
      cmd = { 'typescript-language-server', '--stdio' },
      filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
      root_markers = { 'package.json' },
      single_file_support = false,
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Deno
    vim.lsp.config('denols', {
      cmd = { 'deno', 'lsp' },
      filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
      root_markers = { 'deno.json', 'deno.jsonc' },
      init_options = { lint = true, unstable = true },
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Lua
    vim.lsp.config('lua_ls', {
      cmd = { 'lua-language-server' },
      filetypes = { 'lua' },
      root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
      settings = { Lua = { completion = { callSnippet = 'Replace' } } },
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Go
    vim.lsp.config('gopls', {
      cmd = { 'gopls' },
      filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
      root_markers = { 'go.work', 'go.mod', '.git' },
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- PlantUML
    vim.lsp.config('plantuml_lsp', {
      cmd = { 'plantuml-lsp' },
      filetypes = { 'plantuml', 'puml' },
      root_markers = { '.git' },
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Terraform
    vim.lsp.config('terraformls', {
      cmd = { 'terraform-ls', 'serve' },
      filetypes = { 'terraform', 'tf', 'hcl' },
      root_markers = { '.terraform', '.git' },
      capabilities = capabilities,
      on_attach = on_attach,
    })

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
