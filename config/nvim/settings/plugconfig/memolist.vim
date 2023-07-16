let g:memolist_path = "~/.memolist/memo"
let g:memolist_memo_suffix = "md"
nnoremap <Leader>mn  :MemoNew<CR>
nnoremap <Leader>ml  :Telescope memo list<CR>
nnoremap <Leader>mg  :Telescope memo live_grep<CR>

augroup MemoAutoCommit
  autocmd!
  autocmd BufEnter */.memolist/memo/*.md let b:auto_save = 0
  autocmd BufWritePost */.memolist/memo/*.md silent !memo commit
augroup END
