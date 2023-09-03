return {
  'VidocqH/lsp-lens.nvim',
  event = "LspAttach",
  config = function()
    require 'lsp-lens'.setup({})
  end
}
