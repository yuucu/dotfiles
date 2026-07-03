return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  keys = {
    { '<leader>m', '<cmd>Telescope marks<cr>', desc = 'search by [M]arks' },
    { '<leader>f', '<cmd>Telescope find_files<cr>', desc = 'search [F]iles' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-tree/nvim-web-devicons',
    'fdschmidt93/telescope-egrepify.nvim',
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local egrep_actions = require('telescope._extensions.egrepify.actions')

    telescope.setup({
      defaults = {
        path_display = { 'truncate' },
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      extensions = {
        egrepify = {
          AND = true,
          permutations = false,
          lnum = true,
          lnum_hl = 'EgrepifyLnum',
          col = false,
          col_hl = 'EgrepifyCol',
          title = true,
          filename_hl = 'EgrepifyFile',
          prefixes = {
            ['!'] = { flag = 'invert-match' },
            ['^'] = false,
          },
          mappings = {
            i = {
              ['<C-z>'] = egrep_actions.toggle_prefixes,
              ['<C-a>'] = egrep_actions.toggle_and,
              ['<C-r>'] = egrep_actions.toggle_permutations,
            },
          },
        },
      },
    })

    telescope.load_extension('fzf')
    telescope.load_extension('egrepify')

    vim.keymap.set('n', '<leader>w', require('telescope.builtin').grep_string, { desc = 'search current [W]ord' })
    vim.keymap.set('n', '<leader>g', require('telescope').extensions.egrepify.egrepify, { desc = 'search by [G]rep' })
  end,
}
