" disable compatibility with vi which can cause unexpected issues
set nocompatible
set encoding=utf-8
set regexpengine=2
set noswapfile
set shiftwidth=2
set tabstop=2
set softtabstop=2
set updatetime=100
set expandtab
set shiftround
set showmatch
set splitbelow
set splitright
set laststatus=0
set ruler
set showcmd
set title
set visualbell
set ignorecase
set smartcase
set background=dark
colorscheme lunaperche
set autoread
set autoindent
set incsearch
set hlsearch
set wildcharm=<C-z>
set wildoptions=pum,tagfile
set wildmenu
set history=10000
let &showbreak='+++ '
set lcs=tab:>\ ,trail:-,nbsp:+
set list
syntax on
filetype on

" quickly launch/dismiss netrw
au FileType netrw nnoremap <silent> <buffer> <C-c> <Cmd>Rexplore<CR>
nnoremap <silent> - <Cmd>Explore<CR>

" open the quickfix window whenever a quickfix command is executed
autocmd QuickFixCmdPost [^l]* cwindow | setl cursorline
nnoremap <silent> <Space><Space> :noh<CR>

" list your plugins here
call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-signify'
Plug 'machakann/vim-highlightedyank'
Plug 'ziglang/zig.vim'
call plug#end()

" generate ctags in the background
function! GenerateTags()
  if !executable('ctags')
    echohl WarningMsg | echom 'no ctags installation found' | echohl None
    return
  endif
  let l:job = job_start(['ctags', '--tag-relative=never', '-G', '-R', '.'],
      \ { 'in_io': 'null', 'out_io': 'null', 'err_io': 'null' })
  echom 'generating tagfile..., info: ' . l:job
endfunction
nnoremap <Space>tg :call GenerateTags()<CR>

" navigate within command mode like Emacs
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" find files
nnoremap <Space>e :e %:h<C-z>
nnoremap <Space>b :b <C-z>

" pattern grep
nnoremap <Space>g :vimgrep //f **<S-Left><S-Left><Right>
vnoremap <Space>g "0y:vimgrep /<C-r>=escape(@0,'/\')<CR>/f **<S-Left><Left><Left><Left>
nnoremap <Space>G :vimgrep /<C-r><C-w>/f **
vnoremap // "0y/\V<C-r>=escape(@0,'/\')<CR><CR>

" program to use ripgrep for the :grep command if available
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading\ --column
  set grepformat^=%f:%l:%c:%m
  nnoremap <Space>g :grep! ''<Left>
  vnoremap <Space>g "0y:grep! --case-sensitive '<C-r>0'<Left>
  nnoremap <Space>G :grep! --case-sensitive '<C-r><C-w>'<CR>
  nnoremap <Space>/ :grep! --hidden --no-ignore ''<Left>
endif

" find and replace
nnoremap <Space>r :%s/<C-r><C-w>//gI<Left><Left><Left>
vnoremap <Space>r "0y:%s/<C-r>=escape(@0,'/\')<CR>//gI<Left><Left><Left>

" yank marked text/paste to/from global register
nnoremap <Space>Y "+Y
vnoremap <Space>y "+y
nnoremap <Space>p "+p
nnoremap <Space>P "+P
vnoremap <Space>p "+p

" move between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" language specific config
au FileType c,cpp,java,python setl ts=4 sts=4 sw=4 et
au FileType javascript,typescript setl ts=2 sts=2 sw=2 et
au FileType json setl ts=2 sts=2 sw=2 fp=jq et

" fzf config
let g:fzf_vim = {}
let g:fzf_layout = { 'down': '41%' }
let g:fzf_vim.preview_window = ['right,41%,<70(up,41%)']
let g:highlightedyank_highlight_duration = 150
nnoremap <Space>f <Cmd>Files<CR>
nnoremap <Space>F :let @+=expand('<cword>') \| Files<CR>
nnoremap <Space>b <Cmd>Buffers<CR>

" no background
hi Normal ctermbg=NONE guibg=NONE
hi NormalNC ctermbg=NONE guibg=NONE
hi VertSplit cterm=NONE ctermbg=NONE guibg=NONE
