return {
  {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown', 'mdc' },
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown', 'mdc' }
    end,
  },
  {
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
  },
  {
    'hat0uma/csvview.nvim',
    ft = { 'csv', 'tsv' },
    config = function()
      require('csvview').setup()
      vim.keymap.set('n', '<Space>c', '<cmd>CsvViewToggle<cr>', { desc = 'Toggle CSV view' })
    end,
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
    'nwiizo/marp.nvim',
    ft = 'markdown',
    config = function()
      require('marp').setup({
        marp_command = 'npx @marp-team/marp-cli@latest',
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
        display_timezone = 'Asia/Tokyo',
      })
    end,
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
  {
    "esmuellert/vscode-diff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff",
  }
}
