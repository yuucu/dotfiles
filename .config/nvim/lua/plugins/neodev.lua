return {
  -- Additional lua configuration, makes nvim stuff amazing!
  'folke/neodev.nvim',
  cond = false,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('neodev').setup()
  end
}
