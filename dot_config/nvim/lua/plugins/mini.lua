return {
  {
    "echasnovski/mini.indentscope",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mini.indentscope").setup({
        -- Which character to use for drawing scope indicator
        -- '│', '|', '¦', '┆', '┊', ''
        symbol = "│",
      })
    end,
  },
}
