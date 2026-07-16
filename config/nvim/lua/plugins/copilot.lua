return {
  'github/copilot.vim',
  event = 'InsertEnter',
  cond = function()
    return not vim.g.vscode
  end,
  init = function()
    vim.g.copilot_filetypes = { markdown = true, help = true }
  end,
}
