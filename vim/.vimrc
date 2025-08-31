call plug#begin()

Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'

call plug#end()

inoremap jk <ESC>

let mapleader = "'"

syntax on
set number relativenumber
set noswapfile 
set hlsearch " higlight all results
set ignorecase " ignore case in search
set incsearch " show search results as you type

" Blink cursor on error instead of beeping 
set visualbell

" Encoding
set encoding=utf-8

" Switch tab
nmap <S-Tab> :tabprev<Return>
nmap <Tab> :tabnext<Return>


" Color Scheme
set background=dark
colorscheme gruvbox

