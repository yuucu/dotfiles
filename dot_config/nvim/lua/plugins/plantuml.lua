return {
  -- PlantUML syntax highlighting
  'aklt/plantuml-syntax',
  ft = { 'plantuml', 'puml' },
  config = function()
    -- PlantUMLファイルの設定
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'plantuml',
      callback = function()
        -- インデント設定
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.expandtab = true
        vim.bo.softtabstop = 2
        
        -- 折りたたみ設定
        vim.wo.foldmethod = 'indent'
        vim.wo.foldlevel = 99
        
        -- コメント設定
        vim.bo.commentstring = "' %s"
      end,
    })
  end,
}