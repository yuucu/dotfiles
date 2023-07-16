return {
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  -- event = "VeryLazy",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "williamboman/mason-lspconfig.nvim",
      cmd = { "LspInstall", "LspUninstall" },
      config = function()
        local mason_lspconfig = require("mason-lspconfig")
        mason_lspconfig.setup({
          ensure_installed = { "lua_ls" },
        })
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        mason_lspconfig.setup_handlers({ function(server)
          local opt = {
            -- -- Function executed when the LSP server startup
            -- on_attach = function(client, bufnr)
            --   local opts = { noremap=true, silent=true }
            --   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
            --   vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'
            -- end,
            capabilities = capabilities,
          }
          require("lspconfig")[server].setup(opt)
        end,
        })
      end,
    },
    {
      "lukas-reineke/lsp-format.nvim",
      config = function()
        require("lsp-format").setup {}

        local on_attach = function(client)
          require("lsp-format").on_attach(client)
          -- ... custom code ...
        end
        require("lspconfig").gopls.setup { on_attach = on_attach }
        require("lspconfig").lua_ls.setup { on_attach = on_attach }
      end
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
