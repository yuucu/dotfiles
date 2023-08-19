return {
  {
    'navarasu/onedark.nvim',
    event = "VimEnter",
    cond = false,
  },
  {
    'rebelot/kanagawa.nvim',
    event = "VimEnter",
    cond = false,
  },
  {
    'ayu-theme/ayu-vim',
    -- cond = false,
    event = "VimEnter",
    priority = 1000,
    config = function()
      -- 背景透過
      -- vim.cmd([[hi! Normal ctermbg=NONE guibg=NONE]])
      vim.g.ayucolor = "dark" -- for dark version of theme
      vim.cmd.colorscheme "ayu"
      vim.api.nvim_exec([[
        highlight Visual guibg=#555555
      ]], false)
    end,
  },
  {
    'catppuccin/nvim',
    cond = false,
    event = "VimEnter",
    name = "catppuccin",
    opts = {
      term_colors = true,
      transparent_background = true,
    },
    config = function()
      -- vim.cmd.colorscheme "catppuccin"
      vim.keymap.set("n", "<leader>v", function()
        local cat = require("catppuccin")
        cat.options.transparent_background = not cat.options.transparent_background
        cat.compile()
        vim.cmd.colorscheme(vim.g.colors_name)
      end)
    end,
  },
  {
    '4513ECHO/vim-colors-hatsunemiku',
    event = "VimEnter",
    cond = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "hatsunemiku"
    end,
  },
  {
    'rose-pine/neovim',
    event = "VimEnter",
    priority = 1000,
    cond = false,
    name = 'rose-pine',
    opts = {
      variant = 'dawn',
    },
    config = function()
      vim.cmd.colorscheme "rose-pine"
    end,
  },
  {
    'kyoh86/momiji',
    cond = false,
    priority = 1000,
  },
}
