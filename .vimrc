vim9script

set nocompatible
set regexpengine=2
set laststatus=2
set noswapfile
set showmatch

set splitbelow
set splitright
set title
set visualbell
set ruler

set ignorecase
set smartcase
set autoread
set autoindent
set incsearch
set hlsearch

set wildmenu
set wildoptions=pum,tagfile
set wildcharm=<C-z>
set updatetime=100

set shiftwidth=2
set tabstop=2
set softtabstop=2
set shiftround
set expandtab

set number
set relativenumber
set list
set lcs=tab:>\ ,trail:-,nbsp:+
&showbreak = '+++ '

filetype on
filetype indent on
syntax on
set background=dark
colorscheme retrobox

# keep things simple here, only essentials
call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'mhinz/vim-signify'
Plug 'machakann/vim-highlightedyank'
Plug 'yegappan/lsp'
Plug 'ziglang/zig.vim'
call plug#end()

au FileType c,cpp,zig,java,python setl sw=4 ts=4 sts=4 et
au FileType javascript,typescript setl sw=2 ts=2 sts=2 et
au FileType go setl sw=4 ts=4 sts=4 noet fp=gofmt
au FileType json setl sw=4 ts=4 sts=4 noet fp=jq

autocmd BufRead,BufNewFile *.log,*.log{.*} setl ft=messages
autocmd BufRead,BufNewFile *.psql setl ft=sql

autocmd QuickFixCmdPost [^l]* cwindow
nnoremap <C-l> :nohlsearch<CR>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

# generate tags in the background
def GenTags()
  if !executable('ctags')
    echohl WarningMsg | echomsg 'no ctags installation found' | echohl None
    return
  endif
  var job = job_start(['ctags', '--tag-relative=never', '-G', '-R', '.'],
    { "in_io": "null", "out_io": "null", "err_io": "null" })
  echomsg 'generate tags..., id: ' .. string(job)
enddef
command! -nargs=0 Tags GenTags()

nnoremap - :Explore<CR>
au FileType netrw nnoremap <buffer> <C-c> :Rexplore<CR>

# extend vim grep abilities with ripgrep, result can be accessible through qf list
if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading\ --column
    set grepformat^=%f:%l:%c:%m
    nnoremap <Space>gg :grep! --fixed-strings ''<Left>
    vnoremap <Space>gg "0y:grep! --case-sensitive --fixed-strings '<C-r>0'<Left>
    nnoremap <Space>gw :grep! --case-sensitive --fixed-strings '<C-r><C-w>'<CR>
    nnoremap <Space>/ :grep! --hidden --no-ignore --fixed-strings ''<Left>
endif
vnoremap // "0y/\V<C-r>=escape(@0,'/\')<CR><CR>

nnoremap <Space>e :edit %:h<C-z>
nnoremap <Space>b :buffer 
nnoremap <Space>s :%s/<C-r><C-w>//gI<Left><Left><Left>
vnoremap <Space>s "0y:%s/<C-r>=escape(@0,'/\')<CR>//gI<Left><Left><Left>

# minimal regex files finding using rigrep
const files_cmd = 'rg --files --hidden --follow --glob "!.git" | sort | grep -i '
def FindCommand(pattern: string)
  if filereadable(pattern)
    execute 'edit' fnameescape(pattern)
    return
  endif
  var files = systemlist(files_cmd .. shellescape(pattern))
  if len(files) > 0 && filereadable(files[0])
    execute 'edit' fnameescape(files[0])
  else
    echohl WarningMsg | echo "no file matches" | echohl None
  endif
enddef
def FindComplete(arg_lead: string, cmd_line: string, cursor_pos: number): list<string>
  return systemlist(files_cmd .. shellescape(arg_lead))
enddef
command! -nargs=* -complete=customlist,FindComplete Find FindCommand(<q-args>)
nnoremap <Space>ff :Find 
nnoremap <Space>fw :Find <C-r><C-w>

nnoremap <Space>y "+y
vnoremap <Space>y "+y
nnoremap <Space>p "+p
nnoremap <Space>P "+P
vnoremap <Space>p "+p

hi! Normal ctermbg=NONE guibg=NONE
hi! NormalNC ctermbg=NONE guibg=NONE
hi! SignColumn ctermbg=NONE guibg=NONE

var lsp_opts = {
  ignoreMissingServer: v:true,
  hoverInPreview: v:true,
  omniComplete: v:true,
  showInlayHints: v:true
}
autocmd User LspSetup call LspOptionsSet(lsp_opts)

var lsp_servers = [{
  name: 'clang',
  filetype: ['c', 'cpp', 'proto'],
  path: 'clangd',
  args: ['--background-index']
}, {
  name: 'zls',
  filetype: ['zig', 'zir'],
  path: 'zls'
}, {
  name: 'tsserver',
  filetype: ['javascript', 'typescript'],
  path: 'typescript-language-server',
  args: ['--stdio']
}, {
  name: 'pylsp',
  filetype: ['python'],
  path: 'pylsp'
}]
autocmd User LspSetup call LspAddServer(lsp_servers)
g:highlightedyank_highlight_duration = 150

def LspConfig()
  setlocal tagfunc=lsp#lsp#TagFunc  # go to definition by C-]
  setlocal formatexpr=lsp#lsp#FormatExpr()  # lsp format using gq
  nnoremap <buffer> gri :LspGotoImpl<CR>
  nnoremap <buffer> grr :LspShowReferences<CR>
  nnoremap <buffer> gra :LspCodeAction<CR>
  nnoremap <buffer> grn :LspRename<CR>
  nnoremap <buffer> ]d :LspDiagNext<CR>
  nnoremap <buffer> [d :LspDiagPrev<CR>
  nnoremap <buffer> <C-w>d :LspDiagCurrent<CR>
  nnoremap <buffer> K :LspHover<CR>
enddef
augroup lsp_keymaps
  au!
  au FileType c,cpp,zig,javascript,typescript,python call LspConfig()
augroup END

defcompile
