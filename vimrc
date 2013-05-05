"==============================
" Basic Setting
"==============================
set scrolloff=5
set textwidth=0
set autoread
set backspace=indent,eol,start
set formatoptions=lmoq
set vb t_vb=
set splitbelow

"==============================
" Backup
"==============================
set nobackup
set writebackup

"==============================
" Copy & Paste
"==============================
" use clipboard in OS
" set clipboard+=unnamed
" enable mouse
" set mouse=a
" set guioptions+=a
" set ttymouse=xterm2

" paste from clipboard in Insert Mode
imap <C-p>  <ESC>"*pa

"==============================
" Move
"==============================
"select to EOL in visual mode
vnoremap v $h

"==============================
" Search
"==============================
set wrapscan
set ignorecase
set smartcase
set incsearch
set hlsearch

"nohl with double <Esc>
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"search sellected word with //
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
"replace sellected string with /r
vnoremap /r "xy;%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>

"==============================
" StatusLine
"==============================
set showcmd
set showmode
set laststatus=2
set ruler
"set statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3l,%3c,%3p]
" set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=\ %{fugitive#statusline()}\ %l,%c%V%8P

" function! GetMode()
  " let mode = mode()
  " if mode ==# 'v'
    " let mode = "VISUAL"
  " elseif mode ==# 'V'
    " let mode = "V⋅LINE"
  " elseif mode ==# ''
    " let mode = "V⋅BLOCK"
  " elseif mode ==# 's'
    " let mode = "SELECT"
  " elseif mode ==# 'S'
    " let mode = "S⋅LINE"
  " elseif mode ==# ''
    " let mode = "S⋅BLOCK"
  " elseif mode =~# '\vi'
    " let mode = "INSERT"
  " elseif mode =~# '\v(R|Rv)'
    " let mode = "REPLACE"
  " else
    " " Fallback to normal mode
    " let mode = "NORMAL"
  " endif
  " return mode
" endfunction

" set statusline=
" set statusline+=%1*\ %{&paste?'PASTE\ ':''}
" set statusline+=%2*\ %{GetMode()}

" hi User1 ctermfg=red ctermbg=black
" hi User2 ctermfg=blue ctermbg=grey

"==============================
" Cursor Line
"==============================
" highlighten current row
set cursorline
" line only in current window
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

"==============================
" Colour
"==============================
"syntax hilight
syntax enable

"colorscheme
" colorscheme xoria256
" colorscheme hybrid
colorscheme jellybeans
" colorscheme yuroyoro256
" set background=dark

" colour setting depending terminal type
if &term =~ "xterm-256color" || "screen-256color"
  " 256
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

"colour of completion window
hi PmenuSel cterm=reverse ctermfg=33 ctermbg=222 gui=reverse guifg=#3399ff guibg=#f0e68c

"==============================
" Appearance detail
"==============================
set showmatch
set matchtime=2
set number

" hilight EOL space
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

" display Zenkaku space
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

" for putty?
hi Normal ctermbg=NONE

" for twig syntax hilight
autocmd BufReadPost *.twig set filetype=jinja

" settings of listchars
" set list
" set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%
" set lcs=tab:>., trail:_, extends:\

"==============================
" Edit
"==============================
"insert spaces instead of tab
set expandtab
"set paste with Pt
command! Pt :set paste!

"insert space after comma automatically
inoremap , ,<Space>

"insert close XML tag automatically
augroup MyXML
    autocmd!
    autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
augroup END

" delete EOL space before saving
autocmd BufWritePre * :%s/\s\+$//ge
" translate tab into space before saving
autocmd BufWritePre * :%s/\t/  /ge

" auto close in visual mode
vnoremap { "zdi{<C-R>z}<ESC>
vnoremap [ "zdi[<C-R>z]<ESC>
vnoremap ( "zdi(<C-R>z)<ESC>
vnoremap " "zdi"<C-R>z"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>

" edit and source with Ev/Sv
command! Ev edit $MYVIMRC
command! Sv source $MYVIMRC

"=============================
" Encoding Settings
"=============================
set ffs=unix,dos,mac
set encoding=utf-8

"=============================
" recognize Encode Automatically
"=============================
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif
if has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'
    " iconvがeucJP-msに対応しているかをチェック
    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
    " iconvがJISX0213に対応しているかをチェック
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif
    if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc

        if s:fileencodings_default =~ 'utf-8'
            let &fileencodings = &fileencodings .','. s:fileencodings_default
            let &fileencodings = substitute(&fileencodings, "utf-8", "utf-8,cp932", "g")
        else
            let &fileencodings = &fileencodings .',cp932,'. s:fileencodings_default
        endif
        unlet s:fileencodings_default

    else
       let &fileencodings = &fileencodings .','. s:enc_jis
       set fileencodings+=utf-8,ucs-2le,ucs-2
       if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
            set fileencodings+=cp932
            set fileencodings-=euc-jp
            set fileencodings-=euc-jisx0213
            set fileencodings-=eucjp-ms
            let &encoding = s:enc_euc
            let &fileencoding = s:enc_euc
       else
            let &fileencodings = &fileencodings .','. s:enc_euc
       endif
    endif
    unlet s:enc_euc
    unlet s:enc_jis
endif
if has('autocmd')
    function! AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    autocmd BufReadPost * call AU_ReCheck_FENC()
endif

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
    set ambiwidth=double
endif

"==============================
" Indent Settings
"==============================
set autoindent
set smartindent
set cindent
"Default setting
set tabstop=4 shiftwidth=4 softtabstop=0


"==============================
" setting in each file type
"==============================

if has("autocmd")
    filetype plugin on
    filetype indent on

    autocmd FileType apache     setlocal sw=4 sts=4 ts=4 et
    autocmd FileType aspvbs     setlocal sw=4 sts=4 ts=4 et
    autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
    autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType cs         setlocal sw=4 sts=4 ts=4 et
    autocmd FileType css        setlocal sw=2 sts=2 ts=2 et
    autocmd FileType diff       setlocal sw=4 sts=4 ts=4 et
    autocmd FileType eruby      setlocal sw=4 sts=4 ts=4 et
    autocmd FileType html       setlocal sw=2 sts=2 ts=2 et
    autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
    autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
    autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
    autocmd FileType php        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType python     setlocal sw=4 sts=4 ts=4 et textwidth=80 cinwords=if,elif,else,for,while,try,except,finally,def,class
    autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
    autocmd FileType haml       setlocal sw=2 sts=2 ts=2 et
    autocmd FileType sh         setlocal sw=2 sts=2 ts=2 et
    autocmd FileType sql        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType vb         setlocal sw=4 sts=4 ts=4 et
    autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
    autocmd FileType wsh        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType xhtml      setlocal sw=4 sts=4 ts=4 et
    autocmd FileType xml        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
    autocmd FileType zsh        setlocal sw=2 sts=2 ts=2 et
    autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et
endif

"==============================
" Tag
"==============================
"jump
nnoremap t  <Nop>
nnoremap tt  <C-]>
nnoremap tj  ;<C-u>tag<CR>
nnoremap tk  ;<C-u>pop<CR>
nnoremap tl  ;<C-u>tags<CR>

"==============================
" Key Mapping
"==============================
" move between tabs
nnoremap <C-n> gt
nnoremap <C-p> gT

" insert an empty row
nnoremap O :<C-u>call append(expand('.'), '')<CR>j

"open a current pane as a new tab with C-g
if v:version >= 700
    nnoremap <C-g> :call OpenNewTab()<CR>
    function! OpenNewTab()
        let f = expand("%:p")
        execute ":q"
        execute ":tabnew ".f
    endfunction
endif

" split window
nnoremap <C-w>v :vnew<CR>
nnoremap <C-w>s :new<CR>

" edit tabs
nnoremap <C-w>t :tabnew<CR>
nnoremap <C-w>c :tabclose<CR>

" move a cursor to right with <C-l>
inoremap <C-l> <Right>
" move a cursor to left with <C-h>
inoremap <C-h> <Left>

" open a new tab to copy
if v:version >= 700
  command! Ps call OpenPasteTab()
  function! OpenPasteTab()
    let f = expand("%:p")
    execute ":tabnew ".f
    execute ":set nonumber"
  endfunction
endif

" disable Ex Mode
noremap Q <Nop>

"==============================
" NeoBundle Setting
"==============================
filetype off

if v:version >= 703
  if has('vim_starting')
    set runtimepath+=$HOME/.vim/bundle/neobundle
    call neobundle#rc(expand('~/.vim/bundle'))
  endif

  "" edit
  NeoBundle 'surround.vim'
  " NeoBundle 'Townk/vim-autoclose.git'
  " NeoBundle 'yuroyoro/vim-autoclose.git'
  " NeoBundle 'smartchr'
  " NeoBundle 'YankRing.vim'

  "" completion
  NeoBundle 'Shougo/neocomplcache.git'
  NeoBundle 'Shougo/neosnippet.git'
  " NeoBundle 'Pydiction'

  "" Shougo-san kei?
  NeoBundle 'thinca/vim-quickrun'
  NeoBundle 'Shougo/vimproc.git', {
    \ 'build' : {
    \     'windows' : 'make -f make_mingw32.mak',
    \     'cygwin' : 'make -f make_cygwin.mak',
    \     'mac' : 'make -f make_mac.mak',
    \     'unix' : 'make -f make_unix.mak',
    \    },
    \ }
  NeoBundle 'Shougo/vimshell.git'
  NeoBundle 'Shougo/vimfiler.git',
    \ { 'depends' : 'Shougo/unite.vim' }
  NeoBundle 'Shougo/unite.vim.git'
  NeoBundle 'Shougo/unite-outline'

  "" etc
  NeoBundle 'Shougo/vinarise.git'
  NeoBundle 'tpope/vim-fugitive'
  NeoBundle 'scrooloose/nerdcommenter.git'
  "NeoBundle 'scrooloose/nerdtree'
  NeoBundle 'grep.vim'
  NeoBundle 'taglist.vim'
  NeoBundle 'jimsei/winresizer.git'
  NeoBundle 'Lokaltog/vim-powerline'
  NeoBundle 'kana/vim-arpeggio.git'
  NeoBundle 'kana/vim-smartinput.git'
  NeoBundle 'nathanaelkane/vim-indent-guides.git'
  NeoBundle 'davidhalter/jedi-vim'
  NeoBundle 'rking/ag.vim.git'
  NeoBundle 'scrooloose/syntastic.git'


  ""colorscheme preview with unite-colorscheme
  "NeoBundle 'ujihisa/unite-colorscheme'
  "NeoBundle 'altercation/vim-colors-solarized'
  "NeoBundle 'croaker/mustang-vim'
  "NeoBundle 'jeffreyiacono/vim-colors-wombat'
  "NeoBundle 'nanotech/jellybeans.vim'
  "NeoBundle 'vim-scripts/Lucius'
  "NeoBundle 'vim-scripts/Zenburn'
  "NeoBundle 'mrkn/mrkn256.vim'
  "NeoBundle 'jpo/vim-railscasts-theme'
  "NeoBundle 'therubymug/vim-pyte'
  "NeoBundle 'tomasr/molokai'
  "NeoBundle 'yuroyoro/yuroyoro256.vim'
endif

filetype plugin on
filetype indent on


"==============================
" Completion
"==============================
set wildmenu
set wildchar=<tab>
set wildmode=list:full
set history=1000
set complete+=k

"==============================
" neocomplcache
"==============================
" Disable AutoComplPop. Comment out this line if AutoComplPop is not installed.
" let g:acp_enableAtStartup = 0
" Launches neocomplcache automatically on vim startup.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.(this may make it slow.)
" let g:neocomplcache_enable_camel_case_completion = 1
" Use underscore completion.
let g:neocomplcache_enable_underbar_completion = 1
" Sets minimum char length of syntax keyword.
let g:neocomplcache_min_syntax_length = 3
" buffer file name pattern that locks neocomplcache. e.g. ku.vim or fuzzyfinder
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" display candidate numbers with -
" let g:neocomplcache_enable_quick_match = 1
" Define the number of candidates
let g:neocomplcache_max_list = 20

" Define file-type dependent dictionaries.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword, for minor languages
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
" inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
inoremap <expr><CR>  pumvisible() ?  neocomplcache#close_popup() : "<CR>"

" Enable omni completion. Not required if they are already set elsewhere in .vimrc
" autocmd FileType python     setlocal omnifunc=pythoncomplete#Complete
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType css        setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType xml        setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType php        setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType c          setlocal omnifunc=ccomplete#Complete
autocmd FileType ruby       setlocal omnifunc=rubycomplete#Complete

" Enable heavy omni completion, which require computational power and may stall the vim.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

" include path
let g:neocomplcache_include_paths = {
    \ 'cpp'  : '.,/opt/local/include/gcc46/c++,/opt/local/include,/usr/include',
    \ 'c'    : '.,/usr/include',
    \ 'ruby' : '.,$HOME/.rvm/rubies/**/lib/ruby/1.8/'
    \ }

" specify patterns of included sentences
let g:neocomplcache_include_patterns = {
    \ 'cpp' : '^\s*#\s*include',
    \ 'ruby' : '^\s*require',
    \ 'perl' : '^\s*use',
    \ 'python' : '^\s*import',
    \ 'php' : '^\s*require_once'
    \ }

" analysis patterns of included file names
let g:neocomplcache_include_exprs = {
    \ 'ruby' : substitute(v:fname,'::','/','g')
    \ }

" add files with the following extensions to searching targets
let g:neocomplcache_include_suffixes = {
    \ 'ruby' : '.rb',
    \ 'haskell' : '.hs',
    \ 'python' : '.py',
    \ 'php' : '.php'
    \ }

" for rsense
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
    endif
    let g:rsenseUseOmniFunc = 1
    let g:rsenseHome = expand('~/src/rsense-0.3')

"==============================
" neosnippet
"==============================
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
" imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
" smap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" set snippets directory
let g:neosnippet#snippets_directory='~/dotfiles/snippets'

"==============================
" quickrun
"==============================
let g:quickrun_config = {}
let g:quickrun_config['_'] = {'runner' : 'vimproc'}
let g:quickrun_config['rspec/bundle'] = {
  \ 'type': 'rspec/bundle',
  \ 'command': "rspec",
  \ 'cmdopt': "-l %{line('.')}",
  \ 'exec': "bundle exec %c %o %s ",
  \ 'filetype': 'rspec-result'
  \}
let g:quickrun_config['rspec/normal'] = {
  \ 'type': 'rspec/normal',
  \ 'command': "rspec",
  \ 'cmdopt': "-l %{line('.')}",
  \ 'exec': '%c %o %s',
  \ 'filetype': 'rspec-result'
  \}
function! RSpecQuickrun()
  let b:quickrun_config = {'type' : 'rspec/bundle'}
endfunction
autocmd BufReadPost *_spec.rb call RSpecQuickrun()

"quickrun with \q
nmap <Leader>q :QuickRun<Cr>

"close quickrun pane with q
autocmd FileType qf nnoremap <buffer> q :ccl<CR>

"==============================
" grep.vim
"==============================
" for mac
if has('unix')
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    if system('which gxargs')
      let Grep_Xargs_Path = 'gxargs'
    else
      let Grep_Find_Use_Xargs = 0
    endif
  endif
endif

" Rgrep under the current directory with :gr <args>
command! -nargs=1 Gr :Rgrep <args> *<Enter><CR>
"skip the following files from grep
let Grep_Skip_Dirs = '.svn .git'
let Grep_Skip_Files = '*.bak *~'

"==============================
" YankRing.vim
"==============================
let g:yankring_replace_n_pkey  =  '<m-p>'
let g:yankring_replace_n_nkey  =  '<m-n>'

"==============================
" arpeggio.vim
"==============================
let g:arpeggio_timeoutlen = 200
call arpeggio#load()

" Arpeggioinoremap () ()<Left>
" Arpeggioinoremap [] []<Left>
Arpeggioinoremap <> <><Left>
" Arpeggioinoremap {} {}<Left>
" Arpeggioinoremap '' ''<Left>
" Arpeggioinoremap "" ""<Left>
" Arpeggioinoremap || ||<Left>

"==============================
" Pydiction
"==============================
" let g:pydiction_location  =  '~/.bundle/pydiction/complete-dict'

"==============================
" NERDTree.vim
"==============================
" nnoremap <silent> <F9> :NERDTreeToggle<CR>

"==============================
" vimfiler
"==============================
let g:vimfiler_as_default_explorer = 1
nnoremap <F9> :VimFilerExplorer -buffer-name=explorer -toggle<Cr>
nmap <Leader>f :VimFiler<Cr>
nmap <Leader>fc :VimFilerCreate<Cr>


"==============================
" NERD_commeter.vim
"==============================
" clear default key mappings
"let g:NERDCreateDefaultMappings = 0
" insert space between comments
let NERDSpaceDelims = 1
" toggle with \\
nmap <Leader><Leader> <Plug>NERDCommenterToggle
vmap <Leader><Leader> <Plug>NERDCommenterToggle
" comment out sexy with \\s
vmap <Leader><Leader>s <Plug>NERDCommenterSexy
" comment out block with \\b
vmap <Leader><Leader>b <Plug>NERDCommenterMinimal
" no display error messages
let NERDShutUp=1

"==============================
" winresizer
"==============================
let g:winresizer_enable = 1
let g:winresizer_start_key = '<C-E>'

"==============================
" Fugitive.vim
"==============================
nnoremap <Leader>gd :<C-u>Gdiff<Enter>
nnoremap <Leader>gs :<C-u>Gstatus<Enter>
nnoremap <Leader>gl :<C-u>Glog<Enter>
nnoremap <Leader>ga :<C-u>Gwrite<Enter>
nnoremap <Leader>gc :<C-u>Gcommit<Enter>
nnoremap <Leader>gC :<C-u>Git commit --amend<Enter>
nnoremap <Leader>gb :<C-u>Gblame<Enter>

"==============================
" taglist.Vim
"==============================
set tags=tags
"set tags+=~/.tags
"let Tlist_Ctags_Cmd = '/Applications/MacVim.app/Contents/MacOS/ctags'
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
" let Tlist_Enable_Fold_Column = 1
" let Tlist_Auto_Open = 1
let Tlist_Auto_Update = 1
let Tlist_WinWidth = 30
"map <silent> <leader>tl :Tlist<CR>
nmap <silent> <F10> :TlistToggle<CR>
" nmap <F10> :CMiniBufExplorer<CR>:TrinityToggleTagList<CR>:TMiniBufExplorer<CR>
nmap <Leader>tl :CMiniBufExplorer<CR>:TrinityToggleTagList<CR>:TMiniBufExplorer<CR>

"==============================
" vimshell
"==============================
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
" let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]%p",  "(%s)-[%b|%a]%p")'
let g:vimshell_enable_smart_case = 1

if has('win32') || has('win64')
" Display user name on Windows.
  let g:vimshell_prompt = $USERNAME."% "
else
" Display user name on Linux.
  let g:vimshell_prompt = $USER."% "

" Use zsh history.
let g:vimshell_external_history_path = expand('~/.zsh-history')

  call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
  call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
  let g:vimshell_execute_file_list['zip'] = 'zipinfo'
  call vimshell#set_execute_file('tgz,gz', 'gzcat')
  call vimshell#set_execute_file('tbz,bz2', 'bzcat')
endif

function! g:my_chpwd(args, context)
  call vimshell#execute('echo "chpwd"')
endfunction
function! g:my_emptycmd(cmdline, context)
  call vimshell#execute('echo "emptycmd"')
  return a:cmdline
endfunction
function! g:my_preprompt(args, context)
  call vimshell#execute('echo "preprompt"')
endfunction
function! g:my_preexec(cmdline, context)
  call vimshell#execute('echo "preexec"')

  if a:cmdline =~# '^\s*diff\>'
    call vimshell#set_syntax('diff')
  endif
  return a:cmdline
endfunction

autocmd FileType vimshell
\| call vimshell#set_alias('ll',  'ls -l .*')
\| call vimshell#altercmd#define('ll', 'ls -l')
\| call vimshell#altercmd#define('la', 'ls -al')
\| call vimshell#hook#set('chpwd', ['g:my_chpwd'])
\| call vimshell#hook#set('emptycmd', ['g:my_emptycmd'])
\| call vimshell#hook#set('preprompt', ['g:my_preprompt'])
\| call vimshell#hook#set('preexec', ['g:my_preexec'])

command! Vs :VimShell

"==============================
" smartchr.vim
"==============================
" inoremap <expr> = smartchr#loop('=', '==', '=>')
" inoremap <expr> . smartchr#loop('.',  '->', '=>')


" inoremap <buffer><expr> + smartchr#one_of(' + ', ' ++ ', '+')
" inoremap <buffer><expr> +=  smartchr#one_of(' += ')
" inoremap <buffer><expr> - smartchr#one_of(' - ', ' -- ', '-')
" inoremap <buffer><expr> -=  smartchr#one_of(' -= ')
" inoremap <buffer><expr> / smartchr#one_of(' / ', ' // ', '/')
" inoremap <buffer><expr> /=  smartchr#one_of(' /= ')
" inoremap <buffer><expr> * smartchr#one_of(' * ', ' ** ', '*')
" inoremap <buffer><expr> *=  smartchr#one_of(' *= ')
" inoremap <buffer><expr> & smartchr#one_of(' & ', ' && ', '&')
" inoremap <buffer><expr> % smartchr#one_of(' % ', '%')
" inoremap <buffer><expr> =>  smartchr#one_of(' => ')
" inoremap <buffer><expr> <-   smartchr#one_of(' <-  ')
" inoremap <buffer><expr> <Bar> smartchr#one_of(' <Bar> ', ' <Bar><Bar> ', '<Bar>')
" inoremap <buffer><expr> , smartchr#one_of(', ', ',')
" inoremap <buffer><expr> ? smartchr#one_of('? ', '?')
" inoremap <buffer><expr> : smartchr#one_of(': ', '::', ':')

" inoremap <buffer><expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '  : search('\(*\<bar>!\)\%#', 'bcn') ? '= '  : smartchr#one_of(' = ', ' == ', '=')

" inoremap <buffer><expr> } smartchr#one_of('}', '}<cr>')
" inoremap <buffer><expr> ; smartchr#one_of(';', ';<cr>')
" inoremap <buffer><expr> ( smartchr#one_of('( ')
" inoremap <buffer><expr> ) smartchr#one_of(' )')

" inoremap <buffer><expr> ( search('\<\if\%#', 'bcn')? ' (': '('

"==============================
" Unite.vim
"==============================
" The prefix key.
nnoremap    [unite]   <Nop>
nmap    <C-u> [unite]

" file list asynchronously
nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=files_async file_rec/async<CR>
" file list
nnoremap <silent> [unite]F :<C-u>Unite -buffer-name=files file_rec<CR>
" buffer list
nnoremap <silent> [unite]h :<C-u>Unite -no-split buffer file_mru<CR>
" bookmark list
nnoremap <silent> [unite]b :<C-u>Unite bookmark<CR>
" history of changes
nnoremap <silent> [unite]c :<C-u>Unite change jump<CR>
" outline
nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
" yank history
nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>
" add bookmark
nnoremap <silent> [unite]a :<C-u>:UniteBookmarkAdd<CR>
" unite-grep
nnoremap <silent> [unite]g :<C-u>:Unite grep<CR>

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  " Start insert.
  let g:unite_enable_start_insert = 1

  nnoremap <silent> <buffer> <expr> <C-s> unite#do_action('split')
  inoremap <silent> <buffer> <expr> <C-s> unite#do_action('split')

  nnoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
  inoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
endfunction"}}}

let g:unite_source_file_mru_limit = 200
let g:unite_source_history_yank_enable = 1

" for unite-grep
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nocolor --nogroup --hidden'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack-grep')
  let g:unite_source_grep_command = 'ack-grep'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -a'
  let g:unite_source_grep_recursive_opt = ''
endif
" unite-grep in visual mode
vnoremap /g y:Unite grep::-iHRn:<C-R>=escape(@", '\\.*$^[]')<CR><CR>

"==============================
" indent-guides
"==============================
let indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_color_change_percent = 90
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=green
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=60
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=236
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_space_guides = 1
let g:indent_guides_exclude_filetypes = ['help',  'nerdtree', 'vimfiler', 'quickfix', 'unite']

"==============================
" smartinput
"==============================
call smartinput#map_to_trigger('i', '#', '#', '#')
call smartinput#define_rule({
\ 'at': '\%#',
\ 'char': '#',
\ 'input': '#{}<Left>',
\ 'filetype': ['ruby'],
\ 'syntax': ['Constant', 'Special'],
\ })

call smartinput#map_to_trigger('i', '<Bar>', '<Bar>', '<Bar>')
call smartinput#define_rule({
\ 'at': '\%#',
\ 'char': '<Bar>',
\ 'input': '<Bar><Bar><Left>',
\ 'filetype': ['ruby'],
\ })

call smartinput#define_rule({
\ 'at': '\({\|\<do\>\)\s*\%#',
\ 'char': '<Bar>',
\ 'input': '<Bar><Bar><Left>',
\ 'filetype': ['ruby'],
\ })

call smartinput#define_rule({
\   'at': '\s\+\%#',
\   'char': '<CR>',
\   'input': "<C-o>:call setline('.',  substitute(getline('.'),  '\\s\\+$',  '',  ''))<CR><CR>",
\   })

call smartinput#map_to_trigger('i',  '<Space>',  '<Space>',  '<Space>')
call smartinput#define_rule({
\   'at'    : '(\%#)',
\   'char'  : '<Space>',
\   'input' : '<Space><Space><Left>',
\   })

call smartinput#define_rule({
\   'at'    : '( \%# )',
\   'char'  : '<BS>',
\   'input' : '<Del><BS>',
\   })

call smartinput#define_rule({
\   'at'       : '\\\%(\|%\|z\)\%#',
\   'char'     : '(',
\   'input'    : '(\)<Left><Left>',
\   'filetype' : ['vim'],
\   'syntax'   : ['String'],
\   })

call smartinput#define_rule({
\   'at'       : '\\(\%#\\)',
\   'char'     : '<BS>',
\   'input'    : '<Del><Del><BS><BS>',
\   'filetype' : ['vim'],
\   'syntax'   : ['String'],
\   })
call smartinput#define_rule({
\   'at'       : '\\[%z](\%#\\)',
\   'char'     : '<BS>',
\   'input'    : '<Del><Del><BS><BS><BS>',
\   'filetype' : ['vim'],
\   'syntax'   : ['String'],
\   })

"==============================
" syntastic
"==============================
" let g:syntastic_always_populate_loc_list = 1

"==============================
" jedi-vim
"==============================
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#goto_command = "<leader>jg"
let g:jedi#get_definition_command = "<leader>jd"
let g:jedi#pydoc = "<Leader>jk"
let g:jedi#rename_command = "<leader>jr"
let g:jedi#related_names_command = "<leader>jn"


"==============================
" powerline
"==============================
"let g:Powerline_symbols = 'fancy'
" let g:Powerline_stl_path_style = 'short'
call Pl#Theme#RemoveSegment('scrollpercent')
call Pl#Theme#RemoveSegment('lineinfo')
" call Pl#Theme#ReplaceSegment('scrollpercent', 'line.cur')
" let s:prev_seg = 'paste_indicator'
" for seg in ['fileformat', 'fileencoding', 'filetype', 'filesize', 'line.tot']
  " call Pl#Theme#InsertSegment(seg, 'after', s:prev_seg)
  " let s:prev_seg = seg
" endfor
" unlet s:prev_seg

" change colour in each mode
call Pl#Hi#Allocate({
  \ 'black'          : 16,
  \ 'white'          : 231,
  \
  \ 'darkestgreen'   : 22,
  \ 'darkgreen'      : 28,
  \
  \ 'darkestcyan'    : 23,
  \ 'mediumcyan'     : 117,
  \
  \ 'darkestblue'    : 24,
  \ 'darkblue'       : 31,
  \
  \ 'darkestred'     : 52,
  \ 'darkred'        : 88,
  \ 'mediumred'      : 124,
  \ 'brightred'      : 160,
  \ 'brightestred'   : 196,
  \
  \
  \ 'darkestyellow'  : 59,
  \ 'darkyellow'     : 100,
  \ 'darkestpurple'  : 55,
  \ 'mediumpurple'   : 98,
  \ 'brightpurple'   : 189,
  \
  \ 'brightorange'   : 208,
  \ 'brightestorange': 214,
  \
  \ 'gray0'          : 233,
  \ 'gray1'          : 235,
  \ 'gray2'          : 236,
  \ 'gray3'          : 239,
  \ 'gray4'          : 240,
  \ 'gray5'          : 241,
  \ 'gray6'          : 244,
  \ 'gray7'          : 245,
  \ 'gray8'          : 247,
  \ 'gray9'          : 250,
  \ 'gray10'         : 252,
  \ })
" 'n': normal mode
" 'i': insert mode
" 'v': visual mode
" 'r': replace mode
" 'N': not active
let g:Powerline#Colorschemes#my#colorscheme = Pl#Colorscheme#Init([
  \ Pl#Hi#Segments(['SPLIT'], {
    \ 'n': ['white', 'gray2'],
    \ 'N': ['gray0', 'gray0'],
    \ }),
  \
  \ Pl#Hi#Segments(['mode_indicator'], {
    \ 'i': ['darkestgreen', 'white', ['bold']],
    \ 'n': ['darkestcyan', 'white', ['bold']],
    \ 'v': ['darkestpurple', 'white', ['bold']],
    \ 'r': ['mediumred', 'white', ['bold']],
    \ 's': ['white', 'gray5', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['fileinfo', 'filename'], {
    \ 'i': ['white', 'darkestgreen', ['bold']],
    \ 'n': ['white', 'darkestblue', ['bold']],
    \ 'v': ['white', 'darkestpurple', ['bold']],
    \ 'r': ['white', 'mediumred', ['bold']],
    \ 'N': ['gray0', 'gray2', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['branch', 'scrollpercent', 'raw', 'filesize'], {
    \ 'n': ['gray2', 'gray7'],
    \ 'N': ['gray0', 'gray2'],
    \ }),
  \
  \ Pl#Hi#Segments(['fileinfo.filepath', 'status'], {
    \ 'n': ['gray10'],
    \ 'N': ['gray5'],
    \ }),
  \
  \ Pl#Hi#Segments(['static_str'], {
    \ 'n': ['white', 'gray4'],
    \ 'N': ['gray1', 'gray1'],
    \ }),
  \
  \ Pl#Hi#Segments(['fileinfo.flags'], {
    \ 'n': ['white'],
    \ 'N': ['gray4'],
    \ }),
  \
  \ Pl#Hi#Segments(['currenttag', 'fileformat', 'fileencoding', 'pwd', 'filetype', 'rvm:string', 'rvm:statusline', 'virtualenv:statusline', 'charcode', 'currhigroup'], {
    \ 'n': ['gray9', 'gray4'],
    \ }),
  \
  \ Pl#Hi#Segments(['lineinfo'], {
    \ 'n': ['gray2', 'gray10'],
    \ 'N': ['gray2', 'gray4'],
    \ }),
  \
  \ Pl#Hi#Segments(['errors'], {
    \ 'n': ['white', 'gray2'],
    \ }),
  \
  \ Pl#Hi#Segments(['lineinfo.line.tot'], {
    \ 'n': ['gray2'],
    \ 'N': ['gray2'],
    \ }),
  \
  \ Pl#Hi#Segments(['paste_indicator', 'ws_marker'], {
    \ 'n': ['white', 'brightred', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['gundo:static_str.name', 'command_t:static_str.name'], {
    \ 'n': ['white', 'mediumred', ['bold']],
    \ 'N': ['brightred', 'darkestred', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['gundo:static_str.buffer', 'command_t:raw.line'], {
    \ 'n': ['white', 'darkred'],
    \ 'N': ['brightred', 'darkestred'],
    \ }),
  \
  \ Pl#Hi#Segments(['gundo:SPLIT', 'command_t:SPLIT'], {
    \ 'n': ['white', 'darkred'],
    \ 'N': ['white', 'darkestred'],
    \ }),
  \
  \ Pl#Hi#Segments(['ctrlp:focus', 'ctrlp:byfname'], {
    \ 'n': ['brightpurple', 'darkestpurple'],
    \ }),
  \
  \ Pl#Hi#Segments(['ctrlp:prev', 'ctrlp:next', 'ctrlp:pwd'], {
    \ 'n': ['white', 'mediumpurple'],
    \ }),
  \
  \ Pl#Hi#Segments(['ctrlp:item'], {
    \ 'n': ['darkestpurple', 'white', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['ctrlp:marked'], {
    \ 'n': ['brightestred', 'darkestpurple', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['ctrlp:count'], {
    \ 'n': ['darkestpurple', 'white'],
    \ }),
  \
  \ Pl#Hi#Segments(['ctrlp:SPLIT'], {
    \ 'n': ['white', 'darkestpurple'],
    \ }),
  \ ])
