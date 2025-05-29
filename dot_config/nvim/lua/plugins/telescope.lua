return {
  'nvim-telescope/telescope.nvim',
  cmd = {
    "Telescope",
  },
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>m", "<cmd>Telescope marks<cr>",      desc = "search by [M]arks" },
    { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "search [F]iles" },
    -- { "<leader>g", "<cmd>Telescope live_grep<cr>",  desc = "search by [G]rep" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "fdschmidt93/telescope-egrepify.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local egrep_actions = require "telescope._extensions.egrepify.actions"
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
      extensions = {
        egrepify = {
          -- intersect tokens in prompt ala "str1.*str2" that ONLY matches
          -- if str1 and str2 are consecutively in line with anything in between (wildcard)
          AND = true,                   -- default
          permutations = false,         -- opt-in to imply AND & match all permutations of prompt tokens
          lnum = true,                  -- default, not required
          lnum_hl = "EgrepifyLnum",     -- default, not required, links to `Constant`
          col = false,                  -- default, not required
          col_hl = "EgrepifyCol",       -- default, not required, links to `Constant`
          title = true,                 -- default, not required, show filename as title rather than inline
          filename_hl = "EgrepifyFile", -- default, not required, links to `Title`
          -- suffix = long line, see screenshot
          -- EXAMPLE ON HOW TO ADD PREFIX!
          prefixes = {
            -- ADDED ! to invert matches
            -- example prompt: ! sorter
            -- matches all lines that do not comprise sorter
            -- rg --invert-match -- sorter
            ["!"] = {
              flag = "invert-match",
            },
            -- HOW TO OPT OUT OF PREFIX
            -- ^ is not a default prefix and safe example
            ["^"] = false
          },
          -- default mappings
          mappings = {
            i = {
              -- toggle prefixes, prefixes is default
              ["<C-z>"] = egrep_actions.toggle_prefixes,
              -- toggle AND, AND is default, AND matches tokens and any chars in between
              ["<C-a>"] = egrep_actions.toggle_and,
              -- toggle permutations, permutations of tokens is opt-in
              ["<C-r>"] = egrep_actions.toggle_permutations,
            },
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("egrepify")
    -- telescope.load_extension("egrepify")
    -- See `:help telescope.builtin`
    -- vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files, { desc = 'search [F]iles' })
    -- vim.keymap.set('n', '<leader>g', require('telescope.builtin').live_grep, { desc = 'search by [G]rep' })
    -- vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
    -- vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers, { desc = 'Find existing [B]uffers' })
    -- vim.keymap.set('n', '<leader>h', require('telescope.builtin').help_tags, { desc = 'search [H]elp' })
    vim.keymap.set('n', '<leader>w', require('telescope.builtin').grep_string, { desc = 'search current [W]ord' })
    vim.keymap.set('n', '<leader>g', require "telescope".extensions.egrepify.egrepify, { desc = 'search by [G]rep' })
    -- vim.keymap.set('n', '<leader>g', require "telescope".extensions.egrepify.egrepify {}, { desc = 'search by [G]rep' })
    -- vim.keymap.set('n', '<leader>d', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
  end,
}
