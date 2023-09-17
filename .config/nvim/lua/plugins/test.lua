return {
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
    "ggandor/leap.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- makes some plugins dot-repeatable like leap
      { "tpope/vim-repeat", event = "VeryLazy" },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
    },
    config = function(_, opts)
      require('leap').add_default_mappings()
      vim.keymap.del({ 'x', 'o' }, 'x')
      vim.keymap.del({ 'x', 'o' }, 'X')
    end,
  },
  {
    event = { "BufReadPre", "BufNewFile" },
    "shortcuts/no-neck-pain.nvim",
    opts = {
      buffers = {
        wo = {
          fillchars = "eob: ",
        },
      },
    },
  },
}
