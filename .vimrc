set nocompatible
set regexpengine=2
set noswapfile
set splitbelow
set splitright

set title
set ruler
set showmatch
set ignorecase
set smartcase
set autoread
set autoindent

set incsearch
set hlsearch
set visualbell
set showcmd
set showmode

set updatetime=256
set wildmenu
set wildoptions=pum,tagfile
set wildcharm=<C-z>

set shiftwidth=2
set tabstop=2
set softtabstop=2
set shiftround
set expandtab

set notermguicolors
set background=dark
set laststatus=2

set list
set lcs=tab:>\ ,trail:-,nbsp:+
let &showbreak = '+++ '

filetype on
filetype indent on
syntax on

nnoremap <Space>e :edit %:h<C-z>
nnoremap <Space>b :buffer 
nnoremap <Space>s :%s/<C-r><C-w>//gI<Left><Left><Left>
vnoremap <Space>s "0y:%s/<C-r>=escape(@0,'/\')<CR>//gI<Left><Left><Left>
vnoremap // "0y/\V<C-r>=escape(@0,'/\')<CR><CR>

nnoremap <C-l> :nohlsearch<CR>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
autocmd QuickFixCmdPost [^l]* cwindow
autocmd FileType help,qf,messages,fugitive,fugitiveblame nnoremap <buffer> q :q<CR>

nnoremap <silent> - :Explore<CR>
autocmd FileType netrw nnoremap <silent> <buffer> <C-c> :Rex<CR>

autocmd BufRead,BufNewFile *.log,*.log{.*} setl ft=messages
autocmd BufRead,BufNewFile *.psql setl ft=sql
autocmd FileType vim setl keywordprg=:help

nnoremap <Space>y "+y
vnoremap <Space>y "+y
nnoremap <Space>p "+p
nnoremap <Space>P "+P
vnoremap <Space>p "+p

" keep things simple here, only essentials
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'machakann/vim-highlightedyank'
Plug 'yegappan/lsp'
Plug 'github/copilot.vim'
call plug#end()

set undodir=~/.vim/undo undofile
colorscheme desert

function! s:gen_tags() abort
  if !executable('ctags')
    echohl WarningMsg | echomsg 'no ctags installation found' | echohl None
    return
  endif

  let l:job = job_start(['ctags', '-G', '-R', '.'],
        \ { 'in_io': 'null', 'out_io': 'null', 'err_io': 'null' })
  echomsg 'generate tags..., id: ' . string(l:job)
endfunction
command! -nargs=0 Tags call <SID>gen_tags()

" extend vim grep abilities with ripgrep, result can be accessible through qf list
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading\ --column
  set grepformat^=%f:%l:%c:%m

  nnoremap <Space>g :grep! --fixed-strings ''<Left>
  vnoremap <Space>g "0y:grep! --case-sensitive --fixed-strings '<C-r>0'<Left>
  nnoremap <Space>G :grep! --case-sensitive --fixed-strings '<C-r><C-w>'<CR>
  nnoremap <Space>/ :grep! --hidden --no-ignore --fixed-strings ''<Left>
endif

function! s:find_complete(arglead, cmdline, cursorpos)
  let l:cmd = 'rg --files --hidden --follow | grep -i ' . shellescape(a:arglead)
  return systemlist(l:cmd)
endfunction

function! s:find_command(pattern) abort
  if filereadable(a:pattern)
    execute 'edit' fnameescape(a:pattern)
    return
  endif

  let l:files = s:find_complete(a:pattern, '', 0)
  if len(l:files) == 0
    echohl WarningMsg | echom "no file matches" | echohl None
  endif
  execute 'edit' fnameescape(l:files[0])
endfunction

" minimal file finder using ripgrep
command! -nargs=1 -complete=customlist,<SID>find_complete Find call <SID>find_command(<q-args>)
nnoremap <Space>f :Find 
nnoremap <Space>F :Find <C-r><C-w>

autocmd FileType go setl sw=4 ts=4 sts=4 noet fp=gofmt
autocmd FileType json setl sw=4 ts=4 sts=4 et fp=jq

autocmd FileType c,cpp,java,python setl sw=4 ts=4 sts=4 et
autocmd FileType c,cpp if filereadable(findfile('CMakeLists.txt', '.;')) |
      \ setl makeprg=cmake\ -S\ %:p:h\ -B\ build\ \&\&\ cmake\ --build\ build |
      \ setl errorformat=%f:%l:%c:\ %m | endif

autocmd FileType java if filereadable(findfile('pom.xml', '.;')) |
      \ setl makeprg=mvn\ compile |
      \ setl errorformat=[ERROR]\ %f:[%l\\,%v]\ %m | endif

autocmd FileType javascript,typescript setl sw=2 ts=2 sts=2 et
autocmd FileType javascript,typescript if filereadable(findfile('package.json', '.;')) |
      \ setl makeprg=npm\ run\ build | endif

hi StatusLine ctermbg=gray ctermfg=black
hi StatusLineNC ctermbg=darkgray ctermfg=black
hi VertSplit cterm=NONE ctermbg=NONE ctermfg=darkgray
hi SignColumn cterm=NONE ctermbg=NONE

" plugins
let g:highlightedyank_highlight_duration = 150

let g:fzf_vim = {}
let g:fzf_layout = { 'down': '41%' }
let g:fzf_vim.preview_window = ['right,41%,<70(up,41%)']
nnoremap <Space>f :Files<CR>
nnoremap <Space>b :Buffers<CR>
nnoremap <Space>g :Rg<CR>

let s:lsp_opts = #{
      \ ignoreMissingServer: v:true,
      \ hoverInPreview: v:true,
      \ omniComplete: v:true,
      \ showInlayHints: v:true
      \ }
autocmd User LspSetup call LspOptionsSet(s:lsp_opts)

let s:lsp_servers = [
      \ #{ name: 'clang', filetype: ['c', 'cpp', 'proto'], path: 'clangd', args: ['--background-index'] },
      \ #{ name: 'pylsp', filetype: ['python'], path: 'pylsp', args: [] },
      \ #{ name: 'tsserver', filetype: ['javascript', 'typescript'], path: 'typescript-language-server', args: ['--stdio'] }
      \ ]
autocmd User LspSetup call LspAddServer(s:lsp_servers)

function! s:lsp_config()
  setl tagfunc=lsp#lsp#TagFunc  " go to definition by C-]
  setl formatexpr=lsp#lsp#FormatExpr()  " lsp format using gq
  nnoremap <buffer> gi :LspGotoImpl<CR>
  nnoremap <buffer> gr :LspShowReferences<CR>
  nnoremap <buffer> gR :LspRename<CR>
  nnoremap <buffer> K :LspHover<CR>
  nnoremap <buffer> ]d :LspDiagNext<CR>
  nnoremap <buffer> [d :LspDiagPrev<CR>
  nnoremap <buffer> <C-w>d :LspDiagCurrent<CR>
  nnoremap <buffer> <Space>a :LspCodeAction<CR>
endfunction
autocmd User LspAttached call <SID>lsp_config()
