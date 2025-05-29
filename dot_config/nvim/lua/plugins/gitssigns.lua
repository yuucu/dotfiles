return {
  -- Adds git releated signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  event = { "BufReadPre", "BufNewFile" },
  cond = function()
    return not vim.g.vscode
  end,
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add          = { text = '┆' },
      change       = { text = '┆' },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
  },
}
