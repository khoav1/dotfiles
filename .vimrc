set nocompatible
set regexpengine=2 noswapfile splitbelow splitright
set ignorecase smartcase title ruler showmatch autoread autoindent
set incsearch hlsearch visualbell showcmd showmode
set timeout timeoutlen=512 updatetime=256
set wildmenu wildoptions=pum,tagfile wildcharm=<C-z>
set shiftwidth=4 tabstop=4 softtabstop=4 shiftround expandtab
set relativenumber background=dark laststatus=2
set wrap list lcs=tab:>\ ,trail:-,nbsp:+
let &showbreak = '+++ '

filetype on
filetype indent on
syntax enable

nnoremap <Space>e :edit %:h<C-z>
nnoremap <Space>b :buffer 
nnoremap <C-l> :nohlsearch<CR>
nnoremap <silent> - :Explore<CR>
nnoremap <Space>y "+y
vnoremap <Space>y "+y
nnoremap <Space>p "+p
nnoremap <Space>P "+P
vnoremap <Space>p "+p

autocmd FileType netrw nnoremap <silent> <buffer> <C-c> :Rexplore<CR>
autocmd FileType netrw,qf setlocal colorcolumn=
autocmd FileType help,qf,messages nnoremap <buffer> q :q<CR>
autocmd QuickFixCmdPost [^l]* cwindow
autocmd BufRead,BufNewFile *.log,*.log{.*} setlocal ft=messages
autocmd BufRead,BufNewFile *.psql setlocal ft=sql
autocmd FileType vim setlocal keywordprg=:help
