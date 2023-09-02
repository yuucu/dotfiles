return {
  "github/copilot.vim",
  -- event = { "BufReadPre", "BufNewFile" },
  -- cmd = "Copilot",
  event = "InsertEnter",
  cond = function()
    return not vim.g.vscode
  end,
  filetypes = {
    markdown = true,
    help = true,
  },
}
