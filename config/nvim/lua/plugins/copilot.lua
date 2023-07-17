return {
  "github/copilot.vim",
  -- event = { "BufReadPre", "BufNewFile" },
  -- cmd = "Copilot",
  event = "InsertEnter",
  filetypes = {
    markdown = true,
    help = true,
  },
}
