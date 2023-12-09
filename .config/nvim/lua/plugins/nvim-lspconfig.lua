return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' },
    { "lukas-reineke/lsp-format.nvim" },
    { 'folke/neodev.nvim' },
  },
  cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lspconfig = require('lspconfig')
    -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    local on_attach = function(client, bufnr)
      require("lsp-format").on_attach(client, bufnr)
      -- ... custom code ...
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        -- インポートの整理
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)

        for client_id, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              local client = vim.lsp.get_client_by_id(client_id)
              local enc = client and client.offset_encoding or "utf-16"
              vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
          end
        end
        -- ドキュメントのフォーマット
        vim.lsp.buf.format({ async = false })
      end
    })

    -- TypeScript
    lspconfig.tsserver.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      single_file_support = false,
      root_dir = lspconfig.util.root_pattern("package.json"),
    }

    -- Deno
    lspconfig.denols.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = lspconfig.util.root_pattern("deno.json"),
      init_options = {
        lint = true,
        unstable = true,
        suggest = {
          imports = {
            hosts = {
              ["https://deno.land"] = true,
              ["https://cdn.nest.land"] = true,
              ["https://crux.land"] = true,
            },
          },
        },
      },
    }


    require('neodev').setup()
    -- Lua
    lspconfig.lua_ls.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace"
          }
        }
      }
    }

    -- Go
    lspconfig.gopls.setup {
      capabilities = capabilities,
      -- on_attach = on_attach,
    }

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      end,
    })
  end,
}
