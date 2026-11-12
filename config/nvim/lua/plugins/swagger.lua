return {
  {
    -- Swagger / OpenAPI ライブプレビュー (swagger-ui-watcher をブラウザで表示)
    'vinnymeller/swagger-preview.nvim',
    cmd = { 'SwaggerPreview', 'SwaggerPreviewStop', 'SwaggerPreviewToggle' },
    ft = { 'yaml', 'json' },
    -- プラグイン側の package.json は ^ 指定のため、バージョンを固定して pnpm で導入する
    build = 'pnpm add --save-exact swagger-ui-watcher@2.1.14',
    config = function()
      require('swagger-preview').setup({
        port = 8000,
        host = 'localhost',
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'yaml', 'json' },
        callback = function()
          vim.keymap.set('n', '<leader>sp', ':SwaggerPreviewToggle<CR>', {
            buffer = true,
            silent = true,
            desc = 'Swagger Preview Toggle',
          })
        end,
      })
    end,
  },
}
