
let mapleader = "\<Space>"

set laststatus=2  

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
 
" other
set number
set autoread
 
" for mac clipboard
set clipboard+=unnamed

 
" docker run -d -p 7843:8080 plantuml/plantuml-server:jetty
let g:preview_uml_url='http://localhost:7843'
 

" rust
syntax enable
filetype plugin indent on
let g:rustfmt_autosave = 1
let g:rust_clip_command = 'pbcopy'
 
set t_Co=256
" set background=dark
" テキスト背景色
au ColorScheme * hi Normal ctermbg=none
" 括弧対応
au ColorScheme * hi MatchParen cterm=bold ctermfg=214 ctermbg=black
" スペルチェック
au Colorscheme * hi SpellBad ctermfg=23 cterm=none ctermbg=none

runtime! settings/init/*.vim
runtime! settings/plugconfig/*.vim
runtime! settings/plugconfig/*.lua

" kotlin対応
autocmd BufReadPost *.kt setlocal filetype=kotlin


let g:git_commit_prefix_lang = 'ja'

