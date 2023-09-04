return {
  'nvim-telescope/telescope.nvim',
  cmd = {
    "Telescope",
  },
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>m", "<cmd>Telescope marks<cr>",      desc = "search by [M]arks" },
    { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "search [F]iles" },
    { "<leader>g", "<cmd>Telescope live_grep<cr>",  desc = "search by [G]rep" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        path_display = { "truncate " },
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })
    telescope.load_extension("fzf")
    -- See `:help telescope.builtin`
    -- vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files, { desc = 'search [F]iles' })
    -- vim.keymap.set('n', '<leader>g', require('telescope.builtin').live_grep, { desc = 'search by [G]rep' })
    -- vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
    -- vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers, { desc = 'Find existing [B]uffers' })
    vim.keymap.set('n', '<leader>h', require('telescope.builtin').help_tags, { desc = 'search [H]elp' })
    vim.keymap.set('n', '<leader>w', require('telescope.builtin').grep_string, { desc = 'search current [W]ord' })
    vim.keymap.set('n', '<leader>d', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.api.nvim_set_keymap("n", "<leader><leader>", "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
      { noremap = true, silent = true })
  end,
}
