
" Ctrl+nでファイルツリーを表示/非表示する
nnoremap <C-n> :Fern . -reveal=% -drawer -toggle -width=40<CR>
let g:fern_disable_startup_warnings = 1
let g:fern#renderer = "nvim-web-devicons"
