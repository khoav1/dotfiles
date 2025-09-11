set nocompatible regexpengine=2 laststatus=2 noswapfile
set splitbelow splitright title ruler showmatch
set ignorecase smartcase autoread autoindent incsearch hlsearch
set visualbell showcmd showmode
set updatetime=256 wildmenu wildoptions=pum,tagfile wildcharm=<c-z>
set shiftwidth=2 tabstop=2 softtabstop=2 shiftround expandtab
set termguicolors background=dark list lcs=tab:>\ ,trail:-,nbsp:+
let &showbreak = '+++ '

filetype on
filetype indent on
syntax on

nnoremap <space>e :edit %:h<c-z>
nnoremap <space>b :buffer 
nnoremap <space>s :%s/<c-r><c-w>//gI<left><left><left>
vnoremap <space>s "0y:%s/<c-r>=escape(@0,'/\')<cr>//gI<left><left><left>
vnoremap // "0y/\V<c-r>=escape(@0,'/\')<cr><cr>

nnoremap <c-l> :nohlsearch<cr>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
autocmd QuickFixCmdPost [^l]* cwindow
autocmd FileType help,qf,messages,fugitive,fugitiveblame nnoremap <buffer> q :q<cr>

nnoremap <silent> - :Explore<cr>
autocmd FileType netrw nnoremap <silent> <buffer> <c-c> :Rex<cr>

autocmd BufRead,BufNewFile *.log,*.log{.*} setl ft=messages
autocmd BufRead,BufNewFile *.psql setl ft=sql
autocmd FileType vim setl keywordprg=:help

nnoremap <space>y "+y
vnoremap <space>y "+y
nnoremap <space>p "+p
nnoremap <space>P "+P
vnoremap <space>p "+p

" keep things simple here, only essentials
call plug#begin()
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
  let l:job = job_start(['ctags', '-G', '-R', '.'], { 'in_io': 'null', 'out_io': 'null', 'err_io': 'null' })
  echomsg 'generate tags..., id: ' . string(l:job)
endfunction
command! -nargs=0 Tags call <SID>gen_tags()

" extend vim grep abilities with ripgrep, result can be accessible through qf list
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading\ --column
  set grepformat^=%f:%l:%c:%m
  nnoremap <space>g :grep! --fixed-strings ''<left>
  vnoremap <space>g "0y:grep! --case-sensitive --fixed-strings '<c-r>0'<left>
  nnoremap <space>G :grep! --case-sensitive --fixed-strings '<c-r><c-w>'<cr>
  nnoremap <space>/ :grep! --hidden --no-ignore --fixed-strings ''<left>
endif

" minimal file finder using ripgrep
let s:files_cmd = 'rg --files --hidden --follow | grep -i '
function! s:find_command(pattern) abort
  if filereadable(a:pattern)
    execute 'edit' fnameescape(a:pattern)
    return
  endif
  let l:files = systemlist(s:files_cmd . shellescape(a:pattern))
  if len(l:files) > 0 && filereadable(l:files[0])
    execute 'edit' fnameescape(l:files[0])
  else
    echohl WarningMsg | echom "no file matches" | echohl None
  endif
endfunction
function! s:find_complete(arglead, cmdline, cursorpos)
  let l:cmd = s:files_cmd . shellescape(a:arglead)
  return systemlist(l:cmd)
endfunction
command! -nargs=1 -complete=customlist,<SID>find_complete Find call <SID>find_command(<q-args>)
nnoremap <space>f :Find 
nnoremap <space>F :Find <c-r><c-w>

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

highlight StatusLine ctermbg=gray guibg=gray ctermfg=black guifg=black
highlight StatusLineNC ctermbg=darkgray guibg=darkgray ctermfg=black guifg=black
highlight VertSplit cterm=NONE ctermbg=NONE ctermfg=darkgray guibg=NONE guifg=darkgray
highlight SignColumn cterm=NONE ctermbg=NONE guibg=NONE

" plugins
let g:highlightedyank_highlight_duration = 150

let s:lsp_opts = #{ ignoreMissingServer: v:true, hoverInPreview: v:true,
      \ omniComplete: v:true, showInlayHints: v:true }
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
  nnoremap <buffer> gri :LspGotoImpl<cr>
  nnoremap <buffer> grr :LspShowReferences<cr>
  nnoremap <buffer> gra :LspCodeAction<cr>
  nnoremap <buffer> grn :LspRename<cr>
  nnoremap <buffer> ]d :LspDiagNext<cr>
  nnoremap <buffer> [d :LspDiagPrev<cr>
  nnoremap <buffer> <c-w>d :LspDiagCurrent<cr>
  nnoremap <buffer> K :LspHover<cr>
endfunction
autocmd User LspAttached call <SID>lsp_config()
