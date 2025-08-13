set nocompatible
set regexpengine=2
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set shiftround
set noswapfile
set showmatch
set splitbelow
set splitright
set title
set visualbell
set ignorecase
set smartcase
set autoread
set autoindent
set incsearch
set hlsearch
set wildmenu
set wildcharm=<c-z>
set history=10000
let &showbreak='+++ '
set lcs=tab:>\ ,trail:-,nbsp:+
set list
set background=dark
filetype on
syntax on
autocmd QuickFixCmdPost [^l]* cwindow
nnoremap <silent> <c-l> :nohlsearch<cr>
cnoremap <c-bs> <c-w>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
nnoremap <space>gg :vimgrep //f **<s-left><s-left><right>
vnoremap <space>gg "0y:vimgrep /<c-r>=escape(@0,'/\')<cr>/f **<s-left><left><left><left>
nnoremap <space>gw :vimgrep /<c-r><c-w>/f **
nnoremap <space>r :%s/<c-r><c-w>//gI<left><left><left>
vnoremap <space>r "0y:%s/<c-r>=escape(@0,'/\')<cr>//gI<left><left><left>
vnoremap // "0y/\V<c-r>=escape(@0,'/\')<cr><cr>
