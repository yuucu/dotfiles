return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    lazy = true,
    opts = {
      {
        float_border = 'rounded',
        call_servers = 'local',
        configure_diagnostics = true,
        setup_servers_on_start = true,
        set_lsp_keymaps = {
          preserve_mappings = false,
          omit = {},
        },
        manage_nvim_cmp = {
          set_sources = 'recommended',
          set_basic_mappings = true,
          set_extra_mappings = false,
          use_luasnip = true,
          set_format = true,
          documentation_window = true,
        },
      }
    },
    config = function(_, opts)
      -- This is where you modify the settings for lsp-zero
      -- Note: autocompletion settings will not take effect
      require('lsp-zero.settings').preset(opts)
    end

  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'L3MON4D3/LuaSnip' },
      { 'hrsh7th/cmp-path' },
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
      -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

      require('lsp-zero.cmp').extend()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_action = require('lsp-zero.cmp').action()

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        },
        completion = {
          completeopt = 'menu,menuone,preview,noselect'
        },
        formatting = {
          fields = { 'abbr', 'kind', 'menu' },
        },
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- null-ls
      { 'jose-elias-alvarez/null-ls.nvim' },
      { 'jay-babu/mason-null-ls.nvim' },
    },
    config = function()
      -- This is where all the LSP shenanigans will live

      local lsp = require('lsp-zero')
      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {
          "gopls",
          "marksman",
          "lua_ls",
          "terraformls",
          "tflint",
          "tsserver",
          "yamlls",
          "dagger",
        },
        handlers = {
          lsp.default_setup,
        }
      })

      lsp.set_sign_icons({
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»'
      })

      lsp.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp.default_keymaps({ buffer = bufnr })
        vim.keymap.set('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>')
        vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
      end)

      lsp.format_on_save({
        format_opts = {
          async = true,
          timeout_ms = 10000,
        },
        servers = {
          ['gopls'] = { 'go' },
          ['lua_ls'] = { 'lua' },
          ['cuelsp'] = { 'cue' },
        }
      })

      -- (Optional) Configure lua language server for neovim
      require('lspconfig').gopls.setup({
        on_attach = function(client, bufnr)
          print('hello gopls')
          vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = '*.go',
            callback = function()
              vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
            end
          })
        end,
      })
      require('lspconfig').denols.setup({
        init_options = {
          lint = true,
        },
      })

      lsp.setup()

      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          -- Replace these with the tools you have installed
          -- make sure the source name is supported by null-ls
          -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
          null_ls.builtins.diagnostics.cspell.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
            diagnostics_postprocess = function(diagnostic)
              -- レベルをWARNに変更（デフォルトはERROR）
              diagnostic.severity = vim.diagnostic.severity["WARN"]
            end,
            -- 起動時に設定ファイル読み込み
            extra_args = { '--config', '~/.config/cspell/cspell.json' },
          }),
        }
      })
      -- See mason-null-ls.nvim's documentation for more details:
      -- https://github.com/jay-babu/mason-null-ls.nvim#setup
      require('mason-null-ls').setup({
        ensure_installed = {
          "hadolint",
          "terraform_fmt",
          "terraform_validate",
          "stylua",
          "gofumpt",
          "golangci_lint",
        },
        automatic_installation = true,
      })
    end
  }
}
