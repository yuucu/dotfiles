-- [[ Configure nvim-cmp ]]
-- See `:help cmp`

return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = "InsertEnter",
  dependencies = {
    -- cmp plugins
    "hrsh7th/nvim-cmp",         -- The completion plugin
    "hrsh7th/cmp-buffer",       -- buffer completions
    "hrsh7th/cmp-path",         -- path completions
    "hrsh7th/cmp-cmdline",      -- cmdline completions
    "saadparwaiz1/cmp_luasnip", -- snippet completions
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",

    -- snippets
    "L3MON4D3/LuaSnip",             --snippet engine
    "rafamadriz/friendly-snippets", -- a bunch of snippets to use

    -- Adds a number of user-friendly snippets
    'onsails/lspkind.nvim',

  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require 'luasnip'
    local lspkind = require('lspkind')
    require('luasnip.loaders.from_vscode').lazy_load()

    local icon = {
      Constructor = "",
      Field = "ﰠ",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "塞",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      EnumMember = "",
      Struct = "פּ",
      Event = "",
      TypeParameter = "",
      Copilot = "",
    }
    cmp.setup({
      enabled = true,
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = "nvim_lua" },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      }),
      formatting = {
        fields = { 'abbr', 'kind', 'menu' },
        format = lspkind.cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          menu = ({
            nvim_lsp = "[LSP]",
            nvim_lua = "[NVIM_LUA]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
          }),
          symbol_map = icon,
        }),
      },
      experimental = {
        ghost_text = true,
      },
    })
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "path" },
        { name = "cmdline" },
      },
    })
  end
}
