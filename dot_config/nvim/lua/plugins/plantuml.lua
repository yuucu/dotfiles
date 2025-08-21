return {
  {
    -- PlantUML syntax highlighting
    'aklt/plantuml-syntax',
    ft = { 'plantuml', 'puml' },
  },
  {
    -- PlantUML previewer
    'weirongxu/plantuml-previewer.vim',
    ft = { 'plantuml', 'puml' },
    dependencies = {
      'tyru/open-browser.vim',
    },
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
          
          -- PlantUMLプレビュー用キーマップ
          local opts = { buffer = true, silent = true }
          vim.keymap.set('n', '<leader>pp', ':PlantumlOpen<CR>', opts)
          vim.keymap.set('n', '<leader>ps', ':PlantumlSave<CR>', opts)
          vim.keymap.set('n', '<leader>pt', ':PlantumlToggle<CR>', opts)
        end,
      })
      
      -- PlantUMLプレビューアーの設定
      vim.g.plantuml_previewer = {
        plantuml_jar_path = vim.fn.expand('~/plantuml.jar'),
        save_format = 'png',
        include_path = vim.fn.expand('~/.plantuml'),
      }
    end,
  },
}