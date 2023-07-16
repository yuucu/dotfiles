return {
  "github/copilot.vim",
  event = { "BufReadPre", "BufNewFile" },
  filetypes = {
    markdown = true,
    help = true,
  },
}
