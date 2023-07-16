return {
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    lazy = true,
  },
  {
    'rebelot/kanagawa.nvim',
  },
  {
    -- Theme inspired by Atom
    'ayu-theme/ayu-vim',
    priority = 1000,
    config = function()
      -- 背景透過
      -- vim.cmd([[hi! Normal ctermbg=NONE guibg=NONE]])
      vim.g.ayucolor = "dark"   -- for dark version of theme
      vim.cmd.colorscheme "ayu"
      vim.cmd([[hi! Visual cterm=reverse gui=reverse]])
      vim.cmd([[highlight FernRootSymbol ctermfg=White guifg=#ffffff]])
    end,
  },
  {
    'catppuccin/nvim',
    lazy = true,
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
  }
}

