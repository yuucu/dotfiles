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
  }
}
