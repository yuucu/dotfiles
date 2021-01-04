
let mapleader = "\<Space>"


call plug#begin('~/.vim/plugged')
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
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

" search
set incsearch
set hlsearch
set ignorecase
set smartcase

set number


" fzf settings
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>g :GFiles<CR>
nnoremap <silent> <leader>G :GFiles?<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>h :History<CR>
nnoremap <silent> <leader>r :Rg<CR>

let $FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/**'"

