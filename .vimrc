vim9script

set nocompatible regexpengine=2 noswapfile splitbelow splitright
set title ruler showmatch ignorecase smartcase autoread autoindent
set incsearch hlsearch visualbell showcmd showmode
set timeout timeoutlen=512 updatetime=256
set wildmenu wildoptions=pum,tagfile wildcharm=<C-z>
set shiftwidth=2 tabstop=2 softtabstop=2 shiftround expandtab
set notermguicolors background=dark laststatus=2
set list lcs=tab:>\ ,trail:-,nbsp:+
&showbreak = '+++ '

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

autocmd BufRead,BufNewFile *.log,*.log{.*} setlocal ft=messages
autocmd BufRead,BufNewFile *.psql setlocal ft=sql
autocmd FileType vim setlocal keywordprg=:help

nnoremap <Space>y "+y
vnoremap <Space>y "+y
nnoremap <Space>p "+p
nnoremap <Space>P "+P
vnoremap <Space>p "+p

# keep things simple here, only essentials
packadd fugitive
packadd commentary
packadd surround
packadd highlightedyank
packadd lsp
packadd copilot

set undodir=~/.vim/undo undofile
colorscheme desert

def GenTags(): void
  if !executable('ctags')
    echohl WarningMsg | echomsg 'no ctags installation found' | echohl None
    return
  endif

  const job = job_start(['ctags', '-G', '-R', '.'], { 'in_io': 'null', 'out_io': 'null', 'err_io': 'null' })
  echomsg 'generate tags..., id: ' .. string(job)
enddef
command! -nargs=0 Tags GenTags()

# extend vim grep abilities with ripgrep, result can be accessible through qf list
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading\ --column
  set grepformat^=%f:%l:%c:%m

  nnoremap <Space>g :grep! --fixed-strings \'\'<Left><Left>
  vnoremap <Space>g "0y:grep! --case-sensitive --fixed-strings \'<C-r>0\'<Left><Left>
  nnoremap <Space>G :grep! --case-sensitive --fixed-strings \'<C-r><C-w>\'<CR>
  nnoremap <Space>/ :grep! --hidden --no-ignore --fixed-strings \'\'<Left><Left>
endif

def FindComplete(arglead: string, cmdline: string, cursorpos: number): list<string>
  const cmd = 'rg --files --hidden --follow | grep -i ' .. shellescape(arglead)
  return systemlist(cmd)
enddef

def FindCommand(pattern: string): void
  if filereadable(pattern)
    execute 'edit' fnameescape(pattern)
    return
  endif

  const files = FindComplete(pattern, '', 0)
  if len(files) == 0
    echohl WarningMsg | echom 'no file matches' | echohl None
    return
  endif
  execute 'edit' fnameescape(files[0])
enddef

# minimal file finder using ripgrep
command! -nargs=1 -complete=customlist,FindComplete Find FindCommand(<q-args>)
nnoremap <Space>f :Find 
nnoremap <Space>F :Find <C-r><C-w>

autocmd FileType go setlocal sw=4 ts=4 sts=4 noet fp=gofmt
autocmd FileType json setlocal sw=4 ts=4 sts=4 et fp=jq

autocmd FileType c,cpp,java,python setlocal sw=4 ts=4 sts=4 et
autocmd FileType c,cpp if filereadable(findfile('CMakeLists.txt', '.;'))
  | setlocal makeprg=cmake\ -S\ %:p:h\ -B\ build\ \&\&\ cmake\ --build\ build
  | setlocal errorformat=%f:%l:%c:\ %m | endif

autocmd FileType java if filereadable(findfile('pom.xml', '.;'))
  | setlocal makeprg=mvn\ compile
  | setlocal errorformat=[ERROR]\ %f:[%l\\,%v]\ %m | endif

autocmd FileType javascript,typescript setlocal sw=2 ts=2 sts=2 et
autocmd FileType javascript,typescript if filereadable(findfile('package.json', '.;'))
  | setlocal makeprg=npm\ run\ build | endif

highlight StatusLine ctermbg=gray ctermfg=black
highlight StatusLineNC ctermbg=darkgray ctermfg=black
highlight VertSplit cterm=NONE ctermbg=NONE ctermfg=darkgray
highlight SignColumn cterm=NONE ctermbg=NONE

# plugins
g:highlightedyank_highlight_duration = 150

const lsp_opts = {
  ignoreMissingServer: v:true,
  hoverInPreview: v:true,
  omniComplete: v:true,
  showInlayHints: v:true
}
g:LspOptionsSet(lsp_opts)

var lsp_servers = [
  { name: 'clang', filetype: ['c', 'cpp', 'proto'], path: 'clangd', args: ['--background-index'] },
  { name: 'pylsp', filetype: ['python'], path: 'pylsp', args: [] },
  { name: 'tsserver', filetype: ['javascript', 'typescript'], path: 'typescript-language-server', args: ['--stdio'] }
]
g:LspAddServer(lsp_servers)

def LspConfig(): void
  setlocal tagfunc=lsp#lsp#TagFunc  # go to definition by C-]
  setlocal formatexpr=lsp#lsp#FormatExpr()  # lsp format using gq
  nnoremap <silent> <buffer> gi :LspGotoImpl<CR>
  nnoremap <silent> <buffer> gr :LspShowReferences<CR>
  nnoremap <silent> <buffer> gR :LspRename<CR>
  nnoremap <silent> <buffer> K :LspHover<CR>
  nnoremap <silent> <buffer> ]d :LspDiagNext<CR>
  nnoremap <silent> <buffer> [d :LspDiagPrev<CR>
  nnoremap <silent> <buffer> <C-w>d :LspDiagCurrent<CR>
  nnoremap <silent> <buffer> <Space>a :LspCodeAction<CR>
enddef
autocmd User LspAttached LspConfig()

defcompile
