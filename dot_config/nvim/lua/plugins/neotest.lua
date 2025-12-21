return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- Adapters
    'nvim-neotest/neotest-go',
    'nvim-neotest/neotest-python',
    'nvim-neotest/neotest-jest',
    'nvim-neotest/neotest-plenary',
  },
  keys = {
    { '<leader>tt', function() require('neotest').run.run() end, desc = 'Run nearest test' },
    { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Run test file' },
    { '<leader>ta', function() require('neotest').run.run(vim.fn.getcwd()) end, desc = 'Run all tests' },
    { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Toggle test summary' },
    { '<leader>to', function() require('neotest').output.open({ enter = true }) end, desc = 'Show test output' },
    { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Toggle output panel' },
    { '<leader>tS', function() require('neotest').run.stop() end, desc = 'Stop test' },
    { '<leader>tw', function() require('neotest').watch.toggle() end, desc = 'Toggle watch mode' },
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('neotest-go')({
          experimental = {
            test_table = true,
          },
          args = { '-count=1', '-timeout=60s', '-v' },
          recursive_run = true,
          -- Go modules のルートを検出
          root_dir = function(path)
            return require('neotest.lib').files.match_root_pattern('go.mod', '.git')(path)
          end,
        }),
        require('neotest-python')({
          dap = { justMyCode = false },
          args = { '--log-level', 'DEBUG' },
          runner = 'pytest',
        }),
        require('neotest-jest')({
          jestCommand = 'npm test --',
          jestConfigFile = 'jest.config.js',
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        }),
        require('neotest-plenary'),
      },
      icons = {
        running_animated = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
      },
      floating = {
        border = 'rounded',
        max_height = 0.6,
        max_width = 0.6,
      },
      quickfix = {
        enabled = true,
        open = false,
      },
      summary = {
        open = 'botright vsplit | vertical resize 50',
      },
      log_level = vim.log.levels.DEBUG,
    })
  end,
}
