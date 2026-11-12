return {
  'vim-jp/vimdoc-ja',
  lazy = true,
  -- 同梱の doc/tags-ja が lazy の helptags で上書きされ、次回の更新が止まるため元に戻す
  -- （build は helptags の後に実行される）
  build = 'git checkout -- doc/tags-ja',
  keys = {
    { 'h', mode = 'c', desc = 'open [H]elp' },
  },
}
