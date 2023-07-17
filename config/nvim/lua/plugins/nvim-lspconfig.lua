return {
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "lvimuser/lsp-inlayhints.nvim",
      event = "VeryLazy",
      config = function()
        vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
        vim.api.nvim_create_autocmd("LspAttach", {
          group = "LspAttach_inlayhints",
          callback = function(args)
            if not (args.data and args.data.client_id) then
              return
            end
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            require("lsp-inlayhints").on_attach(client, bufnr)
          end,
        })
        require("lsp-inlayhints").setup()
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = {
        'williamboman/mason.nvim',
        "lukas-reineke/lsp-format.nvim",
      },
      config = function()
        require("mason").setup()
        local mason_lspconfig = require("mason-lspconfig")

        local handlers = {
          function(server)
            require('lspconfig')[server].setup({
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })
          end,
          ["lua_ls"] = function()
            local on_attach = function(client)
              require("lsp-format").on_attach(client)
            end
            require('lspconfig').lua_ls.setup({
              on_attach = on_attach,
              settings = {
                Lua = {
                  runtime = {
                    -- LuaJIT in the case of Neovim
                    version = 'LuaJIT',
                    path = vim.split(package.path, ';'),
                  },
                  diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                  },
                  workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                      [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                      [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                    },
                  },
                },
              }
            })
          end,
          ["gopls"] = function()
            local on_attach = function(client)
              require("lsp-format").on_attach(client)
            end
            vim.api.nvim_create_autocmd('BufWritePre', {
              callback = function()
                vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
              end
            })
            require('lspconfig').gopls.setup({
              on_attach = on_attach,
              settings = {
              },
            })
          end
        }
        mason_lspconfig.setup({
          ensure_installed = {
            "gopls", -- WARNING: This could be an issue with goenv switching.
            "marksman",
            "lua_ls",
            "terraformls",
            "tflint",
            "tsserver",
            "yamlls",
          },
          handlers = handlers,
        })
      end,
    },
  },
  config = function()
    -- keyboard shortcut
    -- vim.keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>')
    vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    -- vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    -- vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    vim.keymap.set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
    -- vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
    -- vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    -- LSP handlers
    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = true })
    -- Reference highlight
    vim.cmd([[
    set updatetime=500
    highlight LspReferenceText  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
    highlight LspReferenceRead  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
    highlight LspReferenceWrite cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
    ]])
  end,
}
