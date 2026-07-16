-- colorscheme (catppuccin, transparent)
return {
  {
    'catppuccin/nvim',
    event = 'VimEnter',
    priority = 1000,
    name = 'catppuccin',
    cond = function()
      return not vim.g.vscode
    end,
    opts = {
      term_colors = true,
      transparent_background = true,
      transparent_panel = true,
      custom_highlights = {
        Normal = { bg = 'NONE', ctermbg = 'NONE' },
        NonText = { bg = 'NONE', ctermbg = 'NONE' },
        LineNr = { bg = 'NONE', ctermbg = 'NONE' },
        Folded = { bg = 'NONE', ctermbg = 'NONE' },
        EndOfBuffer = { bg = 'NONE', ctermbg = 'NONE' },
      },
      integrations = {
        alpha = true,
        cmp = true,
        gitsigns = true,
        lsp_trouble = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        telescope = true,
        treesitter = true,
        -- which_key = true,
        nvimtree = {
          enabled = true,
          transparent_panel = true,
        },
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin')
    end,
  },
}
