return {
  'hrsh7th/nvim-cmp',
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' },
    { 
      'L3MON4D3/LuaSnip', 
      make =  "make install_jsregexp", 
      dependencies = { "rafamadriz/friendly-snippets" },
      config = function() 
        require('luasnip.loaders.from_vscode').lazy_load() 
      end
    },
    { 'saadparwaiz1/cmp_luasnip', },
    { "hrsh7th/cmp-nvim-lua" },
    { 'hrsh7th/cmp-path' },
    { "hrsh7th/cmp-buffer" },
  },
  config = function()
    local cmp = require('cmp')
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "buffer" },
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      },
      completion = {
        completeopt = 'menu,menuone,preview,noselect'
      },
      formatting = {
        fields = { 'abbr', 'kind', 'menu' },
      },
    })
  end
}
