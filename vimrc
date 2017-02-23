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
" Basic settings {{{1

if &compatible
  set nocompatible
endif

set encoding=utf-8
scriptencoding utf-8
let g:mapleader=','

augroup MyAutoCmd
  autocmd!
  autocmd FileType,Syntax,BufNewFile,BufNew,BufRead *
    \ call s:on_filetype()
  autocmd CursorHold *.toml syntax sync minlines=300
augroup END

if has('vim_starting') && has('reltime')
  let g:startuptime = reltime()
  augroup MyAutoCmd
    autocmd VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
      \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
  augroup END
endif

let $DOTVIM=expand('~/.vim')
let $CACHE = expand('~/.cache')
if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif
" }}}


" -----------------------------------------------------------------------
" Functions {{{1

function! s:get_list(scope, name) " {{{
  return get(a:scope, a:name, [])
endfunction " }}}

function! s:add_to_uniq_list(list, element) " {{{
  return index(a:list, a:element) == -1 ?
    \ add(a:list, a:element) :
    \ a:list
endfunction " }}}

function! s:on_filetype() abort "{{{
  if execute('filetype') =~# 'OFF'
    " Lazy loading
    silent! filetype plugin indent on
    syntax enable
    filetype detect
  endif
endfunction "}}}
" }}}

" -----------------------------------------------------------------------
" Plugins {{{1

" -----------------------------------------------------------------------
" dein {{{2
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
  if has('nvim')
    call dein#load_toml('~/.vim/dein/deineo.toml', {})
  endif

  if dein#tap('deoplete.nvim') && has('nvim')
    call dein#disable('neocomplete.vim')
  endif

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  " Installation check.
  call dein#install()
endif

"}}}
" }}}


" -----------------------------------------------------------------------
" Setting options {{{1

" enable syntax highlighting
syntax enable

set scrolloff=5
set textwidth=0
set autoread
set backspace=indent,eol,start
set formatoptions=lmoq
set vb t_vb=
set splitright
set splitbelow
set nobackup
set writebackup
set noswapfile
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan
set laststatus=2
set cursorline
set showmatch
set matchtime=2
set number
set wildmenu
set wildchar=<tab>
set wildmode=list:full
set history=1000
set complete+=k
set expandtab
set autoindent
set smartindent
set cindent
set tabstop=4
set shiftwidth=4
set softtabstop=0
set t_ut=
set ttyfast
set listchars=tab:▸\ 

set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932
set fileformats=unix,dos,mac

if exists('&ambiwidth')
    set ambiwidth=double
endif

if &term =~ "xterm-256color" || &term =~ "screen-256color"
  set t_Co=256
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~ "xterm-color"
  set t_Co=8
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif
colorscheme molokai

function! s:LetAndMkdir(variable, path)
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
endfunction

if has('persistent_undo')
  set undofile
  call s:LetAndMkdir('&undodir', $DOTVIM.'/undo')
endif

" hilight EOL space and zenkaku space
augroup MyAutoCmd
  autocmd VimEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter * match TrailingSpaces /\s\+$/
  autocmd VimEnter,ColorScheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
  autocmd Syntax * syntax match IdeographicSpace containedin=ALL /　/
augroup END

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
    set ambiwidth=double
endif

" make directory if parent directory does'nt exist
autocmd MyAutoCmd BufNewFile * call PromptAndMakeDirectory()

function! PromptAndMakeDirectory()
  let dir = expand("<afile>:p:h")
  if !isdirectory(dir) && confirm("Create a new directory [".dir."]?", "&Yes\n&No") == 1
    call mkdir(dir, "p")
    " Reset fullpath of the buffer in order to avoid problems when using autochdir.
    file %
  endif
endfunction
"}}}


" -----------------------------------------------------------------------
" Keymappings {{{1

noremap <Space>h ^
noremap <Space>l $
inoremap jk <Esc>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
nnoremap <C-w>v :vnew<CR>
nnoremap <C-w>s :new<CR>
nnoremap <C-w>t :tabnew<CR>
nnoremap <C-w>c :tabclose<CR>
nnoremap <silent> <C-n> gt
nnoremap <silent> <C-p> gT
nnoremap <silent> <Space>o :<C-u>for i in range(1, v:count1) \| call append(line('.'),   '') \| endfor \| silent! call repeat#set("<Space>o", v:count1)<CR>j
nnoremap <silent> <Space>O :<C-u>for i in range(1, v:count1) \| call append(line('.')-1,   '') \| endfor \| silent! call repeat#set("<Space>o", v:count1)<CR>k
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
vnoremap /r "xy;%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <END>

" filetype
nnoremap [filetype]    <Nop>
nmap     <Leader>t     [filetype]

nnoremap [filetype]p   :<C-u>set filetype=php<CR>
nnoremap [filetype]v   :<C-u>set filetype=vim<CR>
nnoremap [filetype]r   :<C-u>set filetype=ruby<CR>
nnoremap [filetype]j   :<C-u>set filetype=javascript<CR>
nnoremap [filetype]s   :<C-u>set filetype=sql<CR>

" change expandtab booster
nnoremap t2 :<C-U>setlocal expandtab shiftwidth=2 tabstop=2<CR>
nnoremap t4 :<C-U>setlocal expandtab shiftwidth=4 tabstop=4<CR>

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


" -----------------------------------------------------------------------
" Commands {{{1

command! Ev edit $MYVIMRC
command! Sv source $MYVIMRC
command! Sw :w !sudo tee >/dev/null %
"}}}


" -----------------------------------------------------------------------
" Filetype {{{1

autocmd MyAutoCmd FileType * setlocal expandtab tabstop=4 shiftwidth=4
autocmd MyAutoCmd FileType vim setlocal expandtab tabstop=2 shiftwidth=2
autocmd MyAutoCmd FileType ruby setlocal expandtab tabstop=2 shiftwidth=2
autocmd MyAutoCmd FileType php setlocal expandtab tabstop=4 shiftwidth=4
autocmd MyAutoCmd FileType javascript setlocal expandtab tabstop=4 shiftwidth=4
autocmd MyAutoCmd FileType sql setlocal expandtab tabstop=2 shiftwidth=2
autocmd MyAutoCmd FileType yaml setlocal expandtab tabstop=2 shiftwidth=2
autocmd MyAutoCmd BufWinEnter,BufNewFile *_spec.rb set filetype=rspec.ruby
autocmd MyAutoCmd FileType rspec.ruby setlocal expandtab tabstop=2 shiftwidth=2
autocmd MyAutoCmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4 list
autocmd MyAutoCmd FileType sh setlocal expandtab tabstop=2 shiftwidth=2
autocmd MyAutoCmd FileType xml setlocal expandtab tabstop=2 shiftwidth=2
autocmd MyAutoCmd FileType xsd setlocal expandtab tabstop=2 shiftwidth=2

autocmd MyAutoCmd BufNewFile,BufRead *.pongo set filetype=twig
" }}}


" -----------------------------------------------------------------------
" __END__  " {{{1
" vim: expandtab softtabstop=2 shiftwidth=2
" vim: foldmethod=marker
" }}}
