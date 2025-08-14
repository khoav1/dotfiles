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
set updatetime=100

set ignorecase
set smartcase
set autoread
set autoindent
set incsearch
set hlsearch

set wildmenu
set wildoptions=pum,tagfile
set wildcharm=<C-z>
set history=10000

set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set shiftround

set number
set relativenumber
set list
set lcs=tab:>\ ,trail:-,nbsp:+
&showbreak = '+++ '

filetype on
syntax on
filetype indent on
set background=dark
colorscheme retrobox

call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'mhinz/vim-signify'
Plug 'machakann/vim-highlightedyank'
Plug 'yegappan/lsp'
call plug#end()

au FileType c,cpp,java,python setl sw=4 ts=4 sts=4 et
au FileType javascript,typescript setl sw=2 ts=2 sts=2 et
au FileType go setl sw=4 ts=4 sts=4 noet fp=gofmt
au FileType json setl sw=4 ts=4 sts=4 noet fp=jq

autocmd BufRead,BufNewFile *.log,*.log{.*} setl ft=messages
autocmd BufRead,BufNewFile *.psql setl ft=sql

autocmd QuickFixCmdPost [^l]* cwindow
au FileType help,qf,fugitive,fugitiveblame nn <silent> <buffer> q <cmd>quit<CR>
nnoremap <silent> <C-l> <cmd>nohlsearch<CR>
cnoremap <C-bs> <C-w>
cnoremap <C-a> <home>
cnoremap <C-e> <end>

# generate tags in the background
def GenTags()
  if !executable('ctags')
    echohl WarningMsg | echomsg 'no ctags installation found' | echohl None
    return
  endif
  var job = job_start(
    ['ctags', '--tag-relative=never', '-G', '-R', '.'],
    { "in_io": "null", "out_io": "null", "err_io": "null" }
  )
  echomsg 'generate tags..., id: ' .. string(job)
enddef
command! -nargs=0 Tag GenTags()

nnoremap - <cmd>Explore<CR>
au FileType netrw nn <buffer> <C-c> <cmd>Rexplore<CR>

# extend vim grep abilities with ripgrep, result can be accessible through qf list
if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading\ --column
    set grepformat^=%f:%l:%c:%m
    nnoremap <space>gg :grep! --fixed-strings ''<left>
    vnoremap <space>gg "0y:grep! --case-sensitive --fixed-strings '<C-r>0'<left>
    nnoremap <space>gw :grep! --case-sensitive --fixed-strings '<C-r><C-w>'<CR>
    nnoremap <space>/ :grep! --hidden --no-ignore --fixed-strings ''<left>
endif
vnoremap // "0y/\V<C-r>=escape(@0,'/\')<CR><CR>

nnoremap <space>r :%s/<C-r><C-w>//gI<left><left><left>
vnoremap <space>r "0y:%s/<C-r>=escape(@0,'/\')<CR>//gI<left><left><left>

# minimal fuzzy files finding using rigrep
const files_cmd = 'rg --files --hidden --follow --glob "!.git" | grep -i '
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
nnoremap <space>ff :Find 
nnoremap <space>fw :Find <C-r><C-w>

nnoremap <space>y "+y
vnoremap <space>y "+y
nnoremap <space>p "+p
nnoremap <space>P "+P
vnoremap <space>p "+p

hi! Normal ctermbg=NONE guibg=NONE
hi! NormalNC ctermbg=NONE guibg=NONE
hi! SignColumn ctermbg=NONE guibg=NONE

g:highlightedyank_highlight_duration = 150

var lsp_opts = {
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
},
{
  name: 'tsserver',
  filetype: ['javascript', 'typescript'],
  path: 'typescript-language-server',
  args: ['--stdio']
},
{
  name: 'pylsp',
  filetype: ['python'],
  path: 'pylsp'
}]
autocmd User LspSetup call LspAddServer(lsp_servers)

def LspKeymapsConfig()
  nnoremap <buffer> gd <cmd>LspGotoDefinition<CR>
  nnoremap <buffer> gi <cmd>LspGotoImpl<CR>
  nnoremap <buffer> gr <cmd>LspShowReferences<CR>
  nnoremap <buffer> ga <cmd>LspCodeAction<CR>
  nnoremap <buffer> ]d <cmd>LspDiagNext<CR>
  nnoremap <buffer> [d <cmd>LspDiagPrev<CR>
  nnoremap <buffer> <C-w>d <cmd>LspDiagCurrent<CR>
  nnoremap <buffer> K <cmd>LspHover<CR>
enddef
augroup lsp_keymaps
  au!
  au FileType c,cpp,javascript,typescript,python LspKeymapsConfig()
augroup END

defcompile
