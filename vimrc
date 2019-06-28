" -----------------------------------------------------------------------
"  ________  _____ ______   ________  _______  ________
" |\   ___ \|\   _ \  _   \|\   __  \|\  ___ \|\_____  \
" \ \  \_|\ \ \  \\\__\ \  \ \  \|\  \ \   __/\|____|\ /_
"  \ \  \ \\ \ \  \\|__| \  \ \   __  \ \  \_|/__   \|\  \
"   \ \  \_\\ \ \  \    \ \  \ \  \ \  \ \  \_|\ \ __\_\  \
"    \ \_______\ \__\    \ \__\ \__\ \__\ \_______\\_______\
"     \|_______|\|__|     \|__|\|__|\|__|\|_______\|_______|
"
" -----------------------------------------------------------------------
" Initialize {{{1

if &compatible
  set nocompatible
endif

set encoding=utf-8
scriptencoding utf-8
let g:mapleader=','

function! s:on_filetype() abort "{{{
  if execute('filetype') =~# 'OFF'
    " Lazy loading
    silent! filetype plugin indent on
    syntax enable
    filetype detect
  endif
endfunction "}}}

augroup MyAutoCmd
  autocmd!
  autocmd FileType,Syntax,BufNewFile,BufNew,BufRead * call s:on_filetype()
  autocmd CursorHold *.toml syntax sync minlines=300
augroup END

let $DOTVIM=expand('~/.vim')
let $CACHE = expand('~/.cache')
if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif

" Disable default plugins
let g:loaded_2html_plugin      = 1
let g:loaded_logiPat           = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_gzip              = 1
let g:loaded_man               = 1
let g:loaded_matchit           = 1
let g:loaded_matchparen        = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_rrhelper          = 1
let g:loaded_shada_plugin      = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_tarPlugin         = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zipPlugin         = 1
" }}}

" Load dein.
let s:dein_dir = expand('$CACHE/dein')
  \. '/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
  let s:dein_repo_dir = s:dein_dir
  if !isdirectory(s:dein_repo_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" dein configurations.
let g:dein#install_progress_type = 'title'
let g:dein#enable_notification = 1

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call dein#load_toml('~/.vim/dein/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.vim/dein/deinlazy.toml', {'lazy' : 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  " Installation check.
  call dein#install()
endif

if has('vim_starting') && !empty(argv())
  call s:on_filetype()
endif

if !has('vim_starting')
  syntax enable
  filetype plugin indent on
endif
" }}}


" -----------------------------------------------------------------------
" Options {{{1

" Search {{{2
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan
" }}}

" Edit {{{2
" tab
set smarttab
set expandtab
" set tabstop=4
" set softtabstop=4
set shiftwidth=2

" indent
set autoindent
set smartindent
set shiftround

" disable modeline
set modelines=0
set nomodeline

" clipboard
if (!has('nvim') || $DISPLAY != '') && has('clipboard')
  if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus
  else
    set clipboard& clipboard+=unnamed
  endif
endif

" keymapping timeout
set timeout
set timeoutlen=3000
set ttimeoutlen=100

" backup
set nobackup
set writebackup
set noswapfile

" disable paste
autocmd MyAutoCmd InsertLeave *
  \ if &paste | setlocal nopaste | echo 'nopaste' | endif |
  \ if &l:diff | diffupdate | endif

" update diff
autocmd MyAutoCmd InsertLeave * if &l:diff | diffupdate | endif

" make directory if parent directory doesn't exist
autocmd MyAutoCmd BufNewFile * call PromptAndMakeDirectory()
function! PromptAndMakeDirectory()
  let dir = expand("<afile>:p:h")
  if !isdirectory(dir) && confirm("Create a new directory [".dir."]?", "&Yes\n&No") == 1
    call mkdir(dir, "p")
    " Reset fullpath of the buffer in order to avoid problems when using autochdir.
    file %
  endif
endfunction

" autofmt
set formatexpr=autofmt#japanese#formatexpr()

" Default home directory.
let t:cwd = getcwd()

" etc
set backspace=indent,eol,start
set hidden
set matchpairs+=<:>
set grepprg=grep\ -inH
set updatetime=1000
set virtualedit=block
set autoread
set formatoptions=lmoq
set mouse-=a
" }}}

" View {{{2
set list
set listchars=tab:▸\ ,trail:-,extends:»,precedes:«,nbsp:%
set laststatus=2
set cmdheight=2
set noshowcmd
set nostartofline
set scrolloff=5
set showmatch
set matchtime=2
set number
set splitright
set splitbelow
set t_ut=
set ttyfast
set colorcolumn=79
let g:did_install_default_menus = 1
set termguicolors
set updatetime=300
set signcolumn=yes

" break
set linebreak
set showbreak=\
set breakat=\ \	;:,!?
set whichwrap+=h,l,<,>,[,],b,s,~
if exists('+breakindent')
  set breakindent
  set wrap
else
  set nowrap
endif

" do not display messages
set shortmess=aTI
set noshowmode
if has('patch-7.4.314')
  set shortmess+=c
else
  autocmd MyAutoCmd VimEnter *
    \ highlight ModeMsg guifg=bg guibg=bg |
    \ highlight Question guifg=bg guibg=bg
endif
if has('patch-7.4.1570')
  set shortmess+=F
endif

" disable bell
set t_vb=
set novisualbell
set belloff=all

" candidate
set nowildmenu
set wildmode=list:longest,full
set history=1000
set showfulltag
set wildoptions=tagfile

" completion
set completeopt=menuone
if has('patch-7.4.775')
  " set completeopt+=noinsert
  " Don't complete from other buffer.
  set complete=.
  " Set popup menu max height.
  set pumheight=20
endif

" window size
set previewheight=8
set helpheight=12

" terminal
if &term =~ "xterm-256color" || &term =~ "screen-256color"
  set t_Co=256
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

" colorscheme
let g:rehash256 = 1
colorscheme molokai
" }}}

" Encoding {{{2
set fileencoding=utf-8
let &fileencodings = join([
  \ 'ucs-bom', 'utf-8', 'iso-2022-jp-3', 'euc-jp', 'sjis', 'cp932'])
set fileformats=unix,dos,mac

if exists('&ambiwidth')
  set ambiwidth=double
endif

if has('multi_byte_ime')
  set iminsert=0 imsearch=0
endif

function! s:LetAndMkdir(variable, path) "{{{
  try
    if !isdirectory(a:path)
      call mkdir(a:path, 'p')
    endif
  catch
    echohl WarningMsg
    echom '[error]' . a:path . 'is exist and is not directory, but is file or something.'
    echohl None
  endtry

  execute printf("let %s = a:path", a:variable)
endfunction "}}}
if has('persistent_undo')
  set undofile
  call s:LetAndMkdir('&undodir', $DOTVIM.'/undo')
endif
"}}}
"}}}


" -----------------------------------------------------------------------
" Keymappings {{{1

" normal mode {{{2
noremap <Space>h ^
noremap <Space>l $
nnoremap <C-w>v :vnew<CR>
nnoremap <C-w>s :new<CR>
nnoremap <C-w>t :tabnew<CR>
nnoremap <silent> <C-n> gt
nnoremap <silent> <C-p> gT
nnoremap <silent> <C-l> :<C-u>redraw!<CR>
nnoremap <silent> <Space>o :<C-u>for i in range(1, v:count1) \| call append(line('.'),   '') \| endfor \| silent! call repeat#set("<Space>o", v:count1)<CR>j
nnoremap <silent> <Space>O :<C-u>for i in range(1, v:count1) \| call append(line('.')-1,   '') \| endfor \| silent! call repeat#set("<Space>o", v:count1)<CR>k
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
" open a current pane as a new tab with C-g
if v:version >= 700
  nnoremap <C-g> :call OpenNewTab()<CR>
  function! OpenNewTab()
    let s:f = expand("%:p")
      execute ":q"
      execute ":tabnew ".s:f
  endfunction
endif
"}}}

" insert mode {{{2
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
"}}}

" virtual mode {{{2
if (!has('nvim') || $DISPLAY != '') && has('clipboard')
  xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
endif
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
vnoremap /r "xy;%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>
"}}}

" command-line mode {{{2
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <END>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-y> <C-r>*
"}}}
"}}}


" -----------------------------------------------------------------------
" Commands {{{1

command! Ev edit $MYVIMRC
command! Sv source $MYVIMRC
command! Sw :w !sudo tee >/dev/null %
"}}}
