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
    config = function()
      if vim.g.vscode then
        vim.cmd.colorscheme('')
      else
        vim.cmd.colorscheme('catppuccin')
      end
      if vim.g.vscode then
        vim.cmd.colorscheme('')
      else
        vim.cmd.colorscheme('catppuccin')
        vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])
        vim.cmd([[highlight NonText guibg=NONE ctermbg=NONE]])
        vim.cmd([[highlight LineNr guibg=NONE ctermbg=NONE]])
        vim.cmd([[highlight Folded guibg=NONE ctermbg=NONE]])
        vim.cmd([[highlight EndOfBuffer guibg=NONE ctermbg=NONE]])
      end
    end,
  },
}
