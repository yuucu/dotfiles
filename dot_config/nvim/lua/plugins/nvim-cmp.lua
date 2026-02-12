return {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    {
      'L3MON4D3/LuaSnip',
      build = 'make install_jsregexp',
      dependencies = 'rafamadriz/friendly-snippets',
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'nvim_lua', priority = 500 },
      }, {
        { name = 'path', priority = 250 },
        { name = 'buffer', priority = 100, keyword_length = 3 },
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, item)
          local menu_icon = {
            nvim_lsp = 'λ',
            luasnip = '⋗',
            buffer = 'Ω',
            path = '🖫',
            nvim_lua = 'Π',
          }
          item.menu = menu_icon[entry.source.name]
          return item
        end,
      },
      experimental = {
        ghost_text = {
          hl_group = 'CmpGhostText',
        },
      },
      performance = {
        debounce = 100, -- 60 → 100: 入力の反応性改善
        throttle = 30,
        fetching_timeout = 1000, -- 500 → 1000: ネットワーク対応
        max_view_entries = 50, -- 表示項目数を制限してパフォーマンス向上
      },
    })
  end,
}
