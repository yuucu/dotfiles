return {
  'github/copilot.vim',
  event = 'InsertEnter',
  cond = function()
    return not vim.g.vscode
  end,
  filetypes = {
    markdown = true,
    help = true,
  },
}
