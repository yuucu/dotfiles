-- 補完エンジン（nvim-cmp から移行）
-- lsp / path / snippets / buffer の各ソースを内蔵しているため、cmp-* 系の依存は不要。
-- snippet は vim.snippet + friendly-snippets（LuaSnip は使わない）。
return {
  'saghen/blink.cmp',
  -- tag 固定。fuzzy matcher の Rust バイナリは tag に対応する release から取得される
  version = 'v1.10.2',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = { 'rafamadriz/friendly-snippets' },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'none',
      ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
      ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    },
    completion = {
      -- 先頭候補を選択状態にするが、確定するまでバッファには挿入しない（旧 completeopt=noinsert 相当）
      list = { selection = { preselect = true, auto_insert = false } },
      menu = { border = 'rounded' },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = 'rounded' },
      },
      ghost_text = { enabled = true },
    },
    signature = { enabled = false }, -- signature は lsp_signature.nvim に任せる
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        buffer = { min_keyword_length = 3 },
      },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
