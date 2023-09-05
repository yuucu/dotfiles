-- Git related plugins
return {
  {
    'tpope/vim-fugitive',
    event = { "BufReadPre", "BufNewFile" },
    cond = function()
      return not vim.g.vscode
    end,
    -- event = "VeryLazy",
    keys = {
      { "git", mode = "c", "<cmd>Git<cr>", desc = "OpenGit" },
    },
    dependencies =
    {
      'tpope/vim-rhubarb',
    },
  },
}
