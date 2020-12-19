
let mapleader = "\<Space>"


call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()




" for US keyboard
nnoremap ; :
nnoremap : ;


" tab indend
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
