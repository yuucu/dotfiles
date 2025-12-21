-- 全 LSP サーバー共通設定
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { 'documentation', 'detail', 'additionalTextEdits' },
}

local on_attach = function(client, bufnr)
  require('lsp-format').on_attach(client, bufnr)
end

return {
  capabilities = capabilities,
  on_attach = on_attach,
}
