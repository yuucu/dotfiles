-- [[ Configure nvim-cmp ]]
-- See `:help cmp`

return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = "InsertEnter",
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',

    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',

    {
      'onsails/lspkind.nvim',
    },
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      build = ":Copilot auth",
      cond = false,
      opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          help = true,
        },
      },
    },
    {
      "zbirenbaum/copilot-cmp",
      dependencies = "copilot.lua",
      -- 使ってない
      cond = false,
      opts = {},
      config = function(_, opts)
        local copilot_cmp = require("copilot_cmp")
        copilot_cmp.setup(opts)
      end,
    }
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require 'luasnip'
    local lspkind = require('lspkind')
    require('luasnip.loaders.from_vscode').lazy_load()
    luasnip.config.setup {}
    cmp.setup({
      enabled = true,
      completion = {
        completeopt = 'menu,menuone,noinsert',
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
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        -- { name = "copilot" },
      }),
      formatting = {
        fields = { 'abbr', 'kind', 'menu' },
        format = lspkind.cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          menu = ({
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
          }),

          symbol_map = {
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
        }),
      },
      experimental = {
        ghost_text = true,
      },
    })
  end
}
