" -----------------------------------------------------------------------
"  ________  ________  ___  ________   _______   ___   ___  ________
" |\   ___ \|\   __  \|\  \|\   ___  \|\  ___ \ |\  \ |\  \|\   ____\
" \ \  \_|\ \ \  \|\  \ \  \ \  \\ \  \ \   __/|\ \  \\_\  \ \  \___|
"  \ \  \ \\ \ \   __  \ \  \ \  \\ \  \ \  \_|/_\ \______  \ \  \____
"   \ \  \_\\ \ \  \ \  \ \  \ \  \\ \  \ \  \_|\ \|_____|\  \ \  ___  \
"    \ \_______\ \__\ \__\ \__\ \__\\ \__\ \_______\     \ \__\ \_______\
"     \|_______|\|__|\|__|\|__|\|__| \|__|\|_______|      \|__|\|_______|
"
" -----------------------------------------------------------------------
" Basic settings {{{1

set encoding=utf-8
scriptencoding utf-8
let g:mapleader=','

augroup MyAutoCmd
  autocmd!
augroup END

if has('vim_starting') && has('reltime')
  let g:startuptime = reltime()
  augroup MyAutoCmd
    autocmd VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
      \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
  augroup END
endif

if has('win64')
  let $DOTVIM=expand('~/vimfiles')
else
  let $DOTVIM=expand('~/.vim')
endif

let $VIMBUNDLE=$DOTVIM.'/bundle'
let $NEOBUNDLEPATH=$VIMBUNDLE.'/neobundle.vim'

function! s:bundled(bundle)
  if !isdirectory($VIMBUNDLE)
    return 0
  endif
  if stridx(&runtimepath, $NEOBUNDLEPATH) == -1
    return 0
  endif

  if a:bundle ==# 'neobundle.vim'
    return 1
  else
    return neobundle#is_installed(a:bundle)
  endif
endfunction
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
" }}}


" -----------------------------------------------------------------------
" Plugins {{{1

" -----------------------------------------------------------------------
" NeoBundle {{{2

if has('vim_starting') && isdirectory($NEOBUNDLEPATH)
  set runtimepath+=$NEOBUNDLEPATH
endif

if s:bundled('neobundle.vim')
  call neobundle#begin($VIMBUNDLE)

  let g:neobundle_default_git_protocol = 'https'
  NeoBundleFetch 'Shougo/neobundle.vim'

  NeoBundle 'Shougo/vimproc.vim', {
    \ 'build' : {
    \   'windows' : 'make -f make_mingw32.mak',
    \   'cygwin' : 'make -f make_cygwin.mak',
    \   'mac' : 'make -f make_mac.mak',
    \   'unix' : 'make -f make_unix.mak',
    \   }
    \ }
  NeoBundleLazy has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
    \ ? 'Shougo/neocomplete.vim' : 'Shougo/neocomplcache.vim'
  NeoBundleLazy 'Shougo/neosnippet.vim'
  NeoBundle 'Shougo/neosnippet-snippets', {'depends': ['Shougo/neosnippet.vim']}
  NeoBundle 'honza/vim-snippets'

  NeoBundleLazy 'Shougo/unite.vim', {'depends': ['Shougo/vimproc.vim']}
  NeoBundle 'Shougo/neomru.vim', {'depends': ['Shougo/unite.vim']}
  NeoBundleLazy 'Shougo/unite-outline', {'depends': ['Shougo/unite.vim']}
  NeoBundleLazy 'Shougo/vimfiler.vim', {'depends': ['Shougo/unite.vim']}
  NeoBundleLazy 'Shougo/neossh.vim', {'depends': ['Shougo/unite.vim']}
  NeoBundleLazy 'osyo-manga/unite-highlight', {'depends': ['Shougo/unite.vim']}
  NeoBundleLazy 'ujihisa/unite-locate', { 'depends' : [ 'Shougo/unite.vim' ] }
  NeoBundleLazy 'ujihisa/unite-colorscheme', {'depends': ['Shougo/unite.vim']}

  NeoBundle 'tpope/vim-fugitive'
  NeoBundleLazy 'gregsexton/gitv', {'depends': ['tpope/vim-fugitive']}
  NeoBundleLazy 'cohama/agit.vim'
  NeoBundle 'airblade/vim-gitgutter'

  NeoBundle 'tpope/vim-surround'
  NeoBundle 'scrooloose/nerdcommenter'
  " NeoBundle 'Yggdroot/indentLine'
  NeoBundle 'nathanaelkane/vim-indent-guides'
  NeoBundle 'vim-airline/vim-airline'
  NeoBundle 'vim-airline/vim-airline-themes', {'depends': ['vim-airline/vim-airline']}
  NeoBundle 'rhysd/accelerated-jk'
  NeoBundleLazy 'thinca/vim-quickrun'
  NeoBundleLazy 'kana/vim-smartinput'
  NeoBundleLazy 'cohama/vim-smartinput-endwise', {'depends': ['kana/vim-smartinput']}
  NeoBundleLazy 'kien/rainbow_parentheses.vim'
  NeoBundleLazy 'mattn/sonictemplate-vim'
  NeoBundle 'jimsei/winresizer'
  NeoBundle 'scrooloose/syntastic'
  NeoBundle 'Shougo/vimshell.vim', {'depends': ['Shougo/vimproc.vim']}

  NeoBundle 'ctrlpvim/ctrlp.vim'
  NeoBundle 'mattn/ctrlp-filer', {'depends': ['ctrlpvim/ctrlp.vim']}
  NeoBundle 'tacahiroy/ctrlp-funky', {'depends': ['ctrlpvim/ctrlp.vim']}

  NeoBundle 'mukiwu/vim-twig'
  NeoBundleLazy 'fatih/vim-go'
  NeoBundleLazy 'tpope/vim-rails'
  NeoBundle 'slim-template/vim-slim'

  NeoBundle 'joedicastro/vim-molokai256'
  NeoBundle 'tomasr/molokai'
  NeoBundle 'nanotech/jellybeans.vim'

  call neobundle#end()

  " Required
  filetype plugin indent on

  " Check uninstalled bundles
  NeoBundleCheck
endif
"}}}


" -----------------------------------------------------------------------
" Plugins' settings {{{2

if neobundle#tap('neocomplete.vim') " {{{3
  call neobundle#config({
    \ 'autoload': {
    \   'insert': 1,
    \ }
    \ })

  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

  " Define dictionary.
  let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  inoremap <expr><C-g> neocomplete#undo_completion()
  inoremap <expr><C-l> neocomplete#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplete#close_popup() . "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplete#close_popup()
  inoremap <expr><C-e>  neocomplete#cancel_popup()
endif " }}}

if neobundle#tap('neocomplcache.vim') " {{{3
  call neobundle#config({
    \ 'autoload': {
    \   'insert': 1,
    \ }
    \ })

  " Use neocomplcache.
  let g:neocomplcache_enable_at_startup = 1
  " Use smartcase.
  let g:neocomplcache_enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplcache_min_syntax_length = 3
  let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

  " Define dictionary.
  let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ }

  " Define keyword.
  if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
  endif
  let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  inoremap <expr><C-g> neocomplcache#undo_completion()
  inoremap <expr><C-l> neocomplcache#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplcache#smart_close_popup() . "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y> neocomplcache#close_popup()
  inoremap <expr><C-e> neocomplcache#cancel_popup()
endif " }}}

if neobundle#tap('neosnippet.vim') " {{{3
  call neobundle#config({
    \ 'autoload': {
    \   'insert': 1,
    \   'filetype': 'snippet',
    \   'commands': ['NeoSnippetEdit', 'NeoSnippetSource'],
    \   'filetypes': ['nsnippet'],
    \   'unite_sources':
    \     ['snippet', 'neosnippet/user', 'neosnippet/runtime'],
    \ }
    \})

  let g:neosnippet#enable_snipmate_compatibility = 1
  " My original snippets
  let g:neosnippet_snippets_directories = s:add_to_uniq_list(
    \ s:get_list(g:, 'neosnippet_snippets_directories'),
    \ '~/.vim/snippets'
    \ )
  let g:neosnippet#snippets_directory = join(g:neosnippet_snippets_directories, ',')
  " <CR> to expand snippet if can
  imap <expr><CR> !pumvisible() ? "\<CR>" :
    \ neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" :
    \ neocomplete#close_popup()
  " supertab.
  imap <expr><TAB> pumvisible() ? "\<C-n>" :
    \ neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" :
    \ "\<TAB>"
  smap <expr><TAB> pumvisible() ? "\<C-n>" :
    \ neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" :
    \ "\<TAB>"

  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
endif " }}}

if neobundle#tap('vim-snippets') " {{{3
  let g:neosnippet_snippets_directories = s:add_to_uniq_list(
    \ s:get_list(g:, 'neosnippet_snippets_directories'),
    \ $VIMBUNDLE . '/vim-snippets/snippets'
    \ )
  let g:neosnippet#snippets_directory = join(g:neosnippet_snippets_directories, ',')
endif " }}}

if neobundle#tap('unite.vim') " {{{3
  call neobundle#config({
    \ 'autoload' : {
    \   'commands' : [
    \     {
    \       'name' : 'Unite',
    \       'complete' : 'customlist,unite#complete_source'
    \     },
    \     'UniteWithCursorWord',
    \     'UniteWithInput'
    \   ]
    \ }
    \ })

  if executable('pt')
    let g:unite_source_grep_command = 'pt'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_grep_encoding = 'utf-8'
  elseif executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
    let g:unite_source_grep_recursive_opt = ''
  endif

  function! s:unite_menu_map_func(key, value)
    let [word, value] = a:value
    if isdirectory(value)
      return {
        \ 'word' : '[directory] ' . word,
        \ 'kind' : 'directory',
        \ 'action__directory' : value
        \ }
    elseif !empty(glob(value))
      return {
        \ 'word' : '[file] ' . word,
        \ 'kind' : 'file',
        \ 'default_action' : 'tabdrop',
        \ 'action__path' : value,
        \ }
    else
      return {
        \ 'word' : '[command] ' . word,
        \ 'kind' : 'command',
        \ 'action__command' : value
        \ }
    endif
  endfunction

  function! neobundle#tapped.hooks.on_source(bundle)
    " General
    let g:unite_force_overwrite_statusline = 0
    let g:unite_kind_jump_list_after_jump_scroll=0
    let g:unite_enable_start_insert = 0
    let g:unite_source_rec_min_cache_files = 1000
    let g:unite_source_rec_max_cache_files = 5000
    let g:unite_source_file_mru_long_limit = 100000
    let g:unite_source_file_mru_limit = 100000
    let g:unite_source_directory_mru_long_limit = 100000
    let g:unite_prompt = '❯ '
    " Use buffer name instead of file path for buffer / buffer_tab source
    let s:filter = { 'name' : 'converter_buffer_word' }

    function! s:filter.filter(candidates, context)
      for candidate in a:candidates
        " if !filereadable(candidate.word)
        " let candidate.word = bufname(candidate.action__buffer_nr)
        " endif
        let candidate.word = bufname(candidate.action__buffer_nr)
        if candidate.word == ''
          let candidate.word = 'No Name'
        end
      endfor
      return a:candidates
    endfunction

    call unite#define_filter(s:filter)
    unlet s:filter
    call unite#custom_source('buffer', 'converters', 'converter_buffer_word')
    call unite#custom_source('buffer_tab', 'converters', 'converter_buffer_word')
    " Unite-menu
    let g:unite_source_menu_menus = get(g:, 'unite_source_menu_menus', {})
    let g:unite_source_menu_menus.global = { 'description' : 'global shortcut' }
    let g:unite_source_menu_menus.unite = { 'description' : 'unite shortcut' }
    let g:unite_source_menu_menus.global.map = function('s:unite_menu_map_func')
    let g:unite_source_menu_menus.unite.map = function('s:unite_menu_map_func')
    let g:unite_source_menu_menus.global.candidates = [
      \ [ '[edit] vimrc' , $MYVIMRC ],
      \ ]
    let g:unite_source_menu_menus.unite.candidates = []
    let g:unite_source_menu_filetype_candidates = {}
    let g:unite_source_menu_filetype_candidates._ = [
      \ [ 'neobundle/update' , ':Unite neobundle/update -log' ],
      \ [ 'neobundle/install' , ':Unite neobundle/install -log' ],
      \ [ 'files', ':Unite -start-insert -buffer-name=files buffer_tab file file_mru'],
      \ [ 'function', ':Unite -start-insert -default-action=edit function'],
      \ [ 'variable', ':Unite -start-insert -default-action=edit variable'],
      \ [ 'outline', ':Unite -start-insert outline'],
      \ [ 'help', ':Unite -start-insert help'],
      \ [ 'buffer', ':Unite -start-insert buffer'],
      \ [ 'line', ':Unite -start-insert -auto-preview -buffer-name=search line'],
      \ [ 'quickfix', ':Unite -no-split -no-quit -auto-preview quickfix -buffer-name=unite_qf'],
      \ [ 'grep', ':Unite grep -max-multi-lines=1 -truncate -default-action=tabopen -buffer-name=unite_grep'],
      \ [ 'source', ':Unite -start-insert source'],
      \ [ 'locate', ':Unite -start-insert locate'],
      \ [ 'theme', ':Unite -auto-preview colorscheme'],
      \ [ 'resume grep', ':UniteResume unite_grep'],
      \ [ 'resume quickfix', ':UniteResume unite_qf'],
      \ ]
  endfunction

  nnoremap <silent> <Space>u :<C-u>call Unite_filetype_menu('-start-insert')<CR>
  function! Unite_filetype_menu(options)
    let filetypes = split(&ft, '\.')
    let candidate_sets = map(
      \ add(filter(filetypes, 'has_key(g:unite_source_menu_filetype_candidates, v:val)'), '_'),
      \ 'g:unite_source_menu_filetype_candidates[v:val]'
      \ )
    let candidates = g:L.flatten(candidate_sets, 1)
    let g:unite_source_menu_menus.unite.candidates = candidates
    execute ':Unite menu:unite ' . a:options
  endfunction
  nnoremap <silent> <C-u>m :<C-u>Unite -start-insert menu:global<CR>
  nnoremap <silent> <C-u>f :<C-u>Unite -start-insert -buffer-name=files buffer_tab file_mru<CR>
  nnoremap <silent> <C-u>B :<C-u>Unite -start-insert buffer<CR>
  nnoremap <silent> <C-u>s :<C-u>Unite -start-insert -auto-preview -no-split -buffer-name=search line<CR>
  nnoremap <silent> <C-u>l :<C-u>Unite -start-insert locate<CR>
  nnoremap <silent> <C-u>g :<C-u>Unite grep -max-multi-lines=1 -truncate -default-action=tabopen -buffer-name=unite_grep<CR>
  nnoremap <silent> <C-u>j :<C-u>Unite -start-insert -buffer-name=files buffer_tab file_mru<CR>
  nnoremap <silent> <C-u>b :<C-u>Unite bookmark:*<CR>
  call unite#custom#source('file_rec/async', 'ignore_pattern', '\(png\|gif\|jpeg\|jpg\)$')
  let g:unite_source_rec_max_cache_files = 20000
  " unite-grep in visual mode
  vnoremap /g y:Unite grep::-iHRn:<C-R>=escape(@", '\\.*$^[]')<CR><CR>
  " change directory as default action
  autocmd MyAutoCmd FileType vimfiler call unite#custom_default_action('directory', 'cd')
  " open bookmarks as VimFiler
  call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')

  if neobundle#is_installed('unite-outline')
    nnoremap <silent> <C-u>h :<C-u>Unite outline<CR>
  endif
endif " }}}

if neobundle#tap('neomru.vim') " {{{3
  let g:neomru#do_validate = 0
endif " }}}

if neobundle#tap('unite-outline') " {{{3
  call neobundle#config({
    \ 'autoload' : {
    \   'unite_sources' : [
    \     'outline',
    \   ],
    \ }
    \ })
endif " }}}

if neobundle#tap('vimfiler.vim') " {{{3
  call neobundle#config({
    \ 'autoload' : {
    \   'commands' : [
    \     {'name': 'VimFiler', 'complete': 'customlist,vimfiler#complete'},
    \     {'name': 'VimFilerExplorer', 'complete': 'customlist,vimfiler#complete'},
    \     {'name': 'Edit', 'complete': 'customlist,vimfiler#complete'},
    \     {'name': 'Write', 'complete': 'customlist,vimfiler#complete'},
    \     'Read',
    \     'Source'
    \   ],
    \   'mappings': '<Plug>(vimfiler_',
    \   'explorer': 1,
    \ }
    \})

  let g:vimfiler_safe_mode_by_default = 0
  let g:unite_kind_file_use_trashbox = 1
  let g:vimfiler_as_default_explorer = 1
  nnoremap <Leader>ff :VimFiler<Cr>
  nnoremap <Leader>fc :VimFilerCreate<Cr>
  nnoremap <Leader>ft :VimFilerExplorer -buffer-name=explorer -toggle -winwidth=65<Cr>
endif " }}}

if neobundle#tap('neossh.vim') " {{{3
  call neobundle#config({
    \})
endif " }}}

if neobundle#tap('unite-highlight') " {{{3
  call neobundle#config({
    \ 'autoload': {
    \   'unite_sources': 'output:highlight',
    \ }
    \})
endif " }}}

if neobundle#tap('unite-locate') " {{{3
  call neobundle#config({
    \ 'autoload' : {
    \   'unite_sources' : [
    \     'locate',
    \   ],
    \ }
    \ })
endif " }}}

if neobundle#tap('unite-colorscheme') " {{{3
  call neobundle#config({
    \ 'autoload' : {
    \   'unite_sources' : [
    \     'colorscheme',
    \   ],
    \   }
    \ })
endif " }}}

if neobundle#tap('vim-fugitive') " {{{3
  nnoremap <Leader>gd :<C-u>Gdiff<Enter>
  nnoremap <Leader>gs :<C-u>Gstatus<Enter>
  nnoremap <Leader>gl :<C-u>Glog<Enter>
  nnoremap <Leader>ga :<C-u>Gwrite<Enter>
  nnoremap <Leader>gc :<C-u>Gcommit<Enter>
  nnoremap <Leader>gC :<C-u>Git commit --amend<Enter>
  nnoremap <Leader>gb :<C-u>Gblame<Enter>
endif " }}}

if neobundle#tap('gitv') " {{{3
  call neobundle#config({
    \ 'autoload': {
    \   'commands': ['Gitv', 'Gitv!']
    \ }
    \ })

  nnoremap <Leader>gv :<C-u>Gitv!<CR>
endif " }}}

if neobundle#tap('agit.vim') " {{{3
  call neobundle#config({
    \ 'autoload': {
    \   'commands': ['Agit']
    \ }
    \ })
endif " }}}

if neobundle#tap('vim-quickrun') " {{{3
  call neobundle#config({
    \ 'autoload': {
    \   'mappings': ['<Plug>(quickrun)'],
    \   'commands': ['QuickRun'],
    \ }
    \ })

  let g:quickrun_config = get(g:, 'quickrun_config', {})
  let g:quickrun_config._ = {
    \ 'runner': 'vimproc',
    \ 'runner/vimproc/updatetime': 10,
    \ 'hook/echo/enable': 1,
    \ 'hook/echo/enable_output_exit': 1,
    \ 'hook/echo/priority_exit': 10000,
    \ }
  let s:rspec = getcwd() . '/bin/rspec'
  let g:quickrun_config['rspec.ruby'] = {
    \ 'command': s:rspec,
    \ 'exec': '%c',
    \ 'cmdopt': '-cfd',
    \ }
    " \ 'exec': 'bundle exec %c',

  nnoremap [quickrun] <Nop>
  nmap <Leader>q [quickrun]
  nnoremap <silent> [quickrun]r :QuickRun<CR>
  nnoremap <silent> [quickrun]l :call QRunRspecCurrentLine()<CR>
  function! QRunRspecCurrentLine()
    let l:line = line(".")
    exe ":QuickRun -exec '%c %s%o' -cmdopt ':" . l:line . " -cfd '"
  endfunction
endif " }}}

if neobundle#tap('nerdcommenter') " {{{3
  call neobundle#config({
    \ 'autoload': {
    \   'mappings': ['inx', '<Plug>NERDCommenter'],
    \ }
    \ })

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
endif " }}}

if neobundle#tap('vim-indent-guides') " {{{3
  let indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_auto_colors = 0
  let g:indent_guides_color_change_percent = 90
  let g:indent_guides_start_level = 2
  let g:indent_guides_guide_size = 1
  let g:indent_guides_space_guides = 1
  let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'vimfiler', 'quickfix', 'unite', 'go']

  augroup MyAutoCmd
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=60
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=236
  augroup END
endif " }}}

if neobundle#tap('vim-airline') " {{{3
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  let g:airline_theme = 'molokai'
  " let g:airline_left_sep = '»'
  " let g:airline_left_sep = ''
  let g:airline_left_sep = '▶'
  " let g:airline_right_sep = '«'
  " let g:airline_right_sep = ''
  let g:airline_right_sep = '◀'
  let g:airline_symbols.linenr = '␊'
  " let g:airline_symbols.linenr = '␤'
  let g:airline_symbols.linenr = '¶'
  let g:airline_symbols.branch = '⎇'
  let g:airline_symbols.paste = 'ρ'
  " let g:airline_symbols.paste = 'Þ'
  " let g:airline_symbols.paste = '∥'
  let g:airline_detect_iminsert = 1

  let g:airline#extensions#branch#enabled = 1
  let g:airline#extensions#branch#format = 1

  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#show_buffers = 0
  let g:airline#extensions#tabline#tab_nr_type = 1

  let g:airline#extensions#whitespace#enabled = 1
  let g:airline#extensions#whitespace#mixed_indent_algo = 1
  let g:airline_symbols.whitespace = 'Ξ'
endif " }}}

if neobundle#tap('vim-smartinput') " {{{3
  call neobundle#config({
    \ 'autoload': {
    \   'insert': 1
    \ }
    \ })

  function! neobundle#tapped.hooks.on_source(bundle)
    call smartinput#clear_rules()
    call smartinput#define_default_rules()
  endfunction

  function! neobundle#tapped.hooks.on_post_source(bundle)
    call smartinput_endwise#define_default_rules()
  endfunction
endif " }}}

if neobundle#tap('vim-smartinput-endwise') " {{{3
  function! neobundle#tapped.hooks.on_post_source(bundle)
    " neosnippet and neocomplete compatible
    call smartinput#map_to_trigger('i', '<Plug>(my_cr)', '<Enter>', '<Enter>')
    imap <expr><CR> !pumvisible() ? "\<Plug>(my_cr)" :
      \ neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" :
      \ neocomplete#close_popup()
      " \ neocomplcache#close_popup()
  endfunction
endif " }}}

if neobundle#tap('rainbow_parentheses.vim') " {{{3
  call neobundle#config({
    \ 'autoload': {
    \   'commands': [
    \     'RainbowParenthesesToggle',
    \     'RainbowParenthesesLoadRound',
    \     'RainbowParenthesesLoadSquare',
    \     'RainbowParenthesesLoadBraces',
    \     'RainbowParenthesesLoadChevrons',
    \   ]
    \ }
    \ })

  augroup MyAutoCmd
    autocmd VimEnter * RainbowParenthesesToggle
    " autocmdau Syntax * RainbowParenthesesLoadRound
    " autocmdau Syntax * RainbowParenthesesLoadSquare
    " autocmdau Syntax * RainbowParenthesesLoadBraces
  augroup END
endif " }}}

if neobundle#tap('sonictemplate-vim') " {{{3
  call neobundle#config({
    \ 'autoload': {
    \   'commands': [
    \     {'name': 'Template', 'complete': 'customlist,sonictemplate#complete'},
    \   ],
    \   'function_prefix': 'sonictemplate'
    \ }
    \ })
  let g:sonictemplate_vim_template_dir = $DOTVIM . '/templates/'
endif " }}}

if neobundle#tap('winresizer') " {{{3
  let g:winresizer_enable = 1
  let g:winresizer_start_key = '<C-E>'
endif " }}}

if neobundle#tap('vim-rails') " {{{3
  call neobundle#config({
    \ 'autoload': {
    \   'filetypes': 'ruby',
    \ }
    \})

  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_build_constraints = 1
endif " }}}

if neobundle#tap('vim-go') " {{{3
  call neobundle#config({
    \ 'autoload': {
    \   'filetypes': 'go',
    \ }
    \})
endif " }}}

if neobundle#tap('syntastic') " {{{3
  let g:syntastic_mode_map = {
  \ 'mode' : 'active',
  \ 'active_filetypes' : ['go', 'ruby'],
  \}
  let g:syntastic_go_checkers = ['go', 'golint']
  let g:syntastic_ruby_checkers = ['rubocop']
endif " }}}

if neobundle#tap('vimshell.vim') " {{{3
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
" let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]%p", "(%s)-[%b|%a]%p")'
let g:vimshell_right_prompt =
      \ 'gita#statusline#format("%{|/}ln%lb%{ <> |}rn%{/|}rb")'
let g:vimshell_prompt = '% '
"let g:vimshell_environment_term = 'xterm'
let g:vimshell_split_command = ''
let g:vimshell_enable_transient_user_prompt = 1
let g:vimshell_force_overwrite_statusline = 1

" let g:vimshell_prompt_expr =
"     \ 'escape($USER . ":". fnamemodify(getcwd(), ":~")."%", "\\[]()?! ")." "'
" let g:vimshell_prompt_pattern = '^\f\+:\%(\f\|\\.\)\+% '

autocmd MyAutoCmd FileType vimshell call s:vimshell_settings()
function! s:vimshell_settings() abort
  " Display user name on Linux.
  "let g:vimshell_prompt = $USER."% "

  " Use zsh history.
  let g:vimshell_external_history_path = expand('~/.zsh-history')

  call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
  call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
  let g:vimshell_execute_file_list['zip'] = 'zipinfo'
  call vimshell#set_execute_file('tgz,gz', 'gzcat')
  call vimshell#set_execute_file('tbz,bz2', 'bzcat')

  " Use gnome-terminal.
  let g:vimshell_use_terminal_command = 'gnome-terminal -e'

  " Initialize execute file list.
  let g:vimshell_execute_file_list = {}
  call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
  let g:vimshell_execute_file_list['rb'] = 'ruby'
  let g:vimshell_execute_file_list['pl'] = 'perl'
  let g:vimshell_execute_file_list['py'] = 'python'
  call vimshell#set_execute_file('html,xhtml', 'gexe firefox')

  inoremap <buffer><expr>'  pumvisible() ? "\<C-y>" : "'"
  imap <buffer><BS>  <Plug>(vimshell_another_delete_backward_char)
  imap <buffer><C-h>  <Plug>(vimshell_another_delete_backward_char)
  imap <buffer><C-k>  <Plug>(vimshell_zsh_complete)
  imap <buffer><C-g>  <Plug>(vimshell_history_neocomplete)

  xmap <buffer> y <Plug>(operator-concealedyank)

  nnoremap <silent><buffer> <C-j>
        \ :<C-u>Unite -buffer-name=files
        \ -default-action=lcd directory_mru<CR>

  call vimshell#altercmd#define('u', 'cdup')
  call vimshell#altercmd#define('g', 'git')
  call vimshell#altercmd#define('i', 'iexe')
  call vimshell#altercmd#define('t', 'texe')
  call vimshell#set_alias('l.', 'ls -d .*')
  call vimshell#set_alias('gvim', 'gexe gvim')
  call vimshell#set_galias('L', 'ls -l')
  call vimshell#set_galias('time', 'exe time -p')
  call vimshell#set_alias('.', 'source')

  " Auto jump.
  call vimshell#set_alias('j', ':Unite -buffer-name=files
        \ -default-action=lcd -no-split -input=$$args directory_mru')

  " Console.
  call vimshell#set_alias('con',
        \ 'lilyterm -d `=b:vimshell.current_dir`')

  call vimshell#set_alias('up', 'cdup')

  call vimshell#hook#add('chpwd',
        \ 'my_chpwd', s:vimshell_hooks.chpwd)
  " call vimshell#hook#add('emptycmd',
  "     \ 'my_emptycmd', s:vimshell_hooks.emptycmd)
  call vimshell#hook#add('notfound',
        \ 'my_notfound', s:vimshell_hooks.notfound)
  call vimshell#hook#add('preprompt',
        \ 'my_preprompt', s:vimshell_hooks.preprompt)
  call vimshell#hook#add('preexec',
        \ 'my_preexec', s:vimshell_hooks.preexec)
  " call vimshell#hook#set('preexec',
  "      \ [s:SID_PREFIX() . 'vimshell_hooks_preexec'])
endfunction

autocmd MyAutoCmd FileType int-* call s:interactive_settings()
function! s:interactive_settings() abort
  call vimshell#hook#set('input', [s:vimshell_hooks.input])
endfunction

autocmd MyAutoCmd FileType term-* call s:terminal_settings()
function! s:terminal_settings() abort
  inoremap <silent><buffer><expr> <Plug>(vimshell_term_send_semicolon)
        \ vimshell#term_mappings#send_key(';')
  inoremap <silent><buffer><expr> j<Space>
        \ vimshell#term_mappings#send_key('j')
  "inoremap <silent><buffer><expr> <Up>
  "      \ vimshell#term_mappings#send_keys("\<ESC>[A")

  " Sticky key.
  imap <buffer><expr> ;  <SID>texe_sticky_func()

  " Escape key.
  iunmap <buffer> <ESC><ESC>
  imap <buffer> <ESC>         <Plug>(vimshell_term_send_escape)
endfunction
function! s:texe_sticky_func() abort "{{{
  let sticky_table = {
        \',' : '<', '.' : '>', '/' : '?',
        \'1' : '!', '2' : '@', '3' : '#', '4' : '$', '5' : '%',
        \'6' : '^', '7' : '&', '8' : '*', '9' : '(', '0' : ')',
        \ '-' : '_', '=' : '+',
        \';' : ':', '[' : '{', ']' : '}', '`' : '~', "'" : "\"", '\' : '|',
        \}
  let special_table = {
        \ "\<ESC>" : "\<ESC>", "\<CR>" : ";\<CR>"
        \ "\<Space>" : "\<Plug>(vimshell_term_send_semicolon)",
        \}

  if mode() !~# '^c'
    echo 'Input sticky key: '
  endif
  let char = ''

  while char == ''
    let char = nr2char(getchar())
  endwhile

  if char =~ '\l'
    return toupper(char)
  elseif has_key(sticky_table, char)
    return sticky_table[char]
  elseif has_key(special_table, char)
    return special_table[char]
  else
    return ''
  endif
endfunction "}}}

let s:vimshell_hooks = {}
function! s:vimshell_hooks.chpwd(args, context) abort
  if len(split(glob('*'), '\n')) < 100
    call vimshell#execute('ls')
  else
    call vimshell#execute('echo "Many files."')
  endif
endfunction
function! s:vimshell_hooks.emptycmd(cmdline, context) abort
  call vimshell#set_prompt_command('ls')
  return 'ls'
endfunction
function! s:vimshell_hooks.notfound(cmdline, context) abort
  return ''
endfunction
function! s:vimshell_hooks.preprompt(args, context) abort
  " call vimshell#execute('echo "preprompt"')
endfunction
function! s:vimshell_hooks.preexec(cmdline, context) abort
  " call vimshell#execute('echo "preexec"')

  let args = vimproc#parser#split_args(a:cmdline)
  if len(args) > 0 && args[0] ==# 'diff'
    call vimshell#set_syntax('diff')
  endif

  return a:cmdline
endfunction
function! s:vimshell_hooks.input(input, context) abort
  " echomsg 'input'
  return a:input
endfunction


if !exists('g:vimshell_interactive_interpreter_commands')
    let g:vimshell_interactive_interpreter_commands = {}
endif
let g:vimshell_interactive_interpreter_commands.python = 'ipython'

" For themis"{{{
" if dein#tap('vim-themis')
  " " Set to $PATH.
  " let s:bin = dein#get('vim-themis').rtp . '/bin'

  " function! s:split_envpath(path) abort "{{{
    " let delimiter = has('win32') ? ';' : ':'
    " if stridx(a:path, '\' . delimiter) < 0
      " return split(a:path, delimiter)
    " endif

    " let split = split(a:path, '\\\@<!\%(\\\\\)*\zs' . delimiter)
    " return map(split,'substitute(v:val, ''\\\([\\'
          " \ . delimiter . ']\)'', "\\1", "g")')
  " endfunction"}}}

  " function! s:join_envpath(list, orig_path, add_path) abort "{{{
    " let delimiter = has('win32') ? ';' : ':'
    " return (stridx(a:orig_path, '\' . delimiter) < 0
          " \ && stridx(a:add_path, delimiter) < 0) ?
          " \   join(a:list, delimiter) :
          " \   join(map(copy(a:list), 's:escape(v:val)'), delimiter)
  " endfunction"}}}

  " " Escape a path for runtimepath.
  " function! s:escape(path) abort "{{{
    " return substitute(a:path, ',\|\\,\@=', '\\\0', 'g')
  " endfunction"}}}

  " let $PATH = s:join_envpath(
        " \ dein#util#_uniq(insert(
        " \    s:split_envpath($PATH), s:bin)), $PATH, s:bin)
  " let $THEMIS_HOME = dein#get('vim-themis').rtp
  " " let $THEMIS_VIM = printf('%s/%s',
  " "       \ fnamemodify(exepath(v:progpath), ':h'),
  " "       \ (has('nvim') ? 'nvim' : 'vim'))

  " unlet s:bin
" endif"}}}
endif " }}}

if neobundle#tap('ctrlp.vim') " {{{3
  let g:ctrlp_map = '<c-z>'
  let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'
endif " }}}

" }}}
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
