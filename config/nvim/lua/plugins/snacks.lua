-- snacks.nvim (bigfile only for now; other modules disabled)
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = {
      enabled = true,
      size = 2 * 1024 * 1024, -- 2 MiB
    },
  },
}
