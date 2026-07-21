-- Highlight, edit, and navigate code
-- main ブランチではモジュール設定が廃止されたため、
-- parser の install と vim.treesitter.start() の呼び出しを自前で行う
local parsers = {
  'go',
  'gosum',
  'gomod',
  'gowork',
  'lua',
  'python',
  'rust',
  'typescript',
  'tsx',
  'vimdoc',
  'vim',
  'kotlin',
  'dockerfile',
  'json',
  'json5',
  'terraform',
  'hcl',
  'proto',
  'bash',
  'c',
  'html',
  'javascript',
  'jsdoc',
  'luadoc',
  'luap',
  'markdown',
  'markdown_inline',
  'query',
  'regex',
  'sql',
  'yaml',
  'css',
  'scss',
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
    require('nvim-treesitter').install(parsers)

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('TreesitterHighlight', { clear = true }),
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if lang and vim.treesitter.language.add(lang) then
          vim.treesitter.start(ev.buf, lang)
        end
      end,
    })
  end,
}
