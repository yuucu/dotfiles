-- AI assistants and integrations (copilot / claude / mcp / editor bridges)
return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    cond = function()
      return not vim.g.vscode
    end,
    init = function()
      vim.g.copilot_filetypes = { markdown = true, help = true }
    end,
  },
  {
    'greggh/claude-code.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    cmd = 'ClaudeCode',
    config = function()
      require('claude-code').setup()
    end,
  },
  {
    'ravitemer/mcphub.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    build = 'npm install -g mcp-hub@latest',
    cmd = 'MCPHub',
    config = function()
      require('mcphub').setup()
    end,
  },
  {
    'yuucu/cursor_open.nvim',
    cmd = { 'CursorOpen' },
    keys = {
      { '<leader>oc', ':CursorOpen<CR>', desc = '[O]pen in [C]ursor' },
      { '<leader>oC', ':CursorOpen!<CR>', desc = '[O]pen in new [C]ursor window' },
    },
    config = function()
      require('cursor_open').setup()
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
}
