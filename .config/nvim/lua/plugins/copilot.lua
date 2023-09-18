return {
  "github/copilot.vim",
  event = "InsertEnter",
  cond = function()
    -- return not vim.g.vscode
    return false
  end,
  filetypes = {
    markdown = true,
    help = true,
  },
}
