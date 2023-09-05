return {
  {
    "olexsmir/gopher.nvim",
    cond = false,
    ft = "go",
    config = function()
      require("gopher").setup()
    end
  },
  {
    "m4xshen/hardtime.nvim",
    event = "VimEnter",
    cond = false,
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {}
  },
  {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    cond = false,
    cmd = {
      "Octo",
    },
    config = function()
      require "octo".setup()
    end
  },
  {
    "cshuaimin/ssr.nvim",
    module = "ssr",
    -- Calling setup is optional.
    lazy = false,
    config = function()
      require("ssr").setup {
        border = "rounded",
        min_width = 50,
        min_height = 5,
        max_width = 120,
        max_height = 25,
        keymaps = {
          close = "q",
          next_match = "n",
          prev_match = "N",
          replace_confirm = "<cr>",
          replace_all = "<leader><cr>",
        },
      }
      vim.keymap.set({ "n", "x" }, "<leader>sr", function() require("ssr").open() end)
    end
  },
  {
    "mbbill/undotree",
    cmd = {
      "UndotreeToggle",
    },
  },
}
