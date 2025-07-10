return {
  {
    'cshuaimin/ssr.nvim',
    module = 'ssr',
    -- Calling setup is optional.
    cond = false,
    config = function()
      require('ssr').setup({
        border = 'rounded',
        min_width = 50,
        min_height = 5,
        max_width = 120,
        max_height = 25,
        keymaps = {
          close = 'q',
          next_match = 'n',
          prev_match = 'N',
          replace_confirm = '<cr>',
          replace_all = '<leader><cr>',
        },
      })
      vim.keymap.set({ 'n', 'x' }, '<leader>sr', function()
        require('ssr').open()
      end)
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown', 'mdc' },
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown', 'mdc' }
    end,
  },
  {
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
  },
  {
    'cameron-wags/rainbow_csv.nvim',
    config = true,
    ft = {
      'csv',
      'tsv',
      'csv_semicolon',
      'csv_whitespace',
      'csv_pipe',
      'rfc_csv',
      'rfc_semicolon',
    },
    cmd = {
      'RainbowDelim',
      'RainbowDelimSimple',
      'RainbowDelimQuoted',
      'RainbowMultiDelim',
    },
  },
  {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    opts = {},
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    event = 'FileType qf',
    config = function()
      require('bqf').setup({
        auto_enable = true,
        func_map = {
          vsplit = '',
        },
      })
    end,
  },
  {
    "nwiizo/marp.nvim",
    ft = "markdown",
    config = function()
      require('marp').setup({
        marp_command = "npx @marp-team/marp-cli@latest",
      })
    end,
  },
  {
    'yuucu/minimemo.nvim',
    lazy = false,
    config = function()
      local constants = require('config.constants')
      require('minimemo').setup({
        memo_dir = constants.DAILY_NOTES.FULL_PATH,
        display_timezone = "Asia/Tokyo",
      })
    end
  },
  {
    'wasabeef/yank-for-claude.nvim',
    config = function()
      require('yank-for-claude').setup()

      -- YankForClaude コマンドを作成
      vim.api.nvim_create_user_command('YankForClaude', function(opts)
        -- ビジュアルモードの選択範囲がある場合
        if opts.range == 2 then
          require('yank-for-claude').yank_visual()
        else
          require('yank-for-claude').yank_line()
        end
      end, { range = true, desc = 'Yank for Claude' })
      
      -- YankForClaudeWithContent コマンドを作成
      vim.api.nvim_create_user_command('YankForClaudeWithContent', function(opts)
        if opts.range == 2 then
          require('yank-for-claude').yank_visual_with_content()
        else
          require('yank-for-claude').yank_line_with_content()
        end
      end, { range = true, desc = 'Yank with content for Claude' })
    end,
    lazy = false,
  },
}
