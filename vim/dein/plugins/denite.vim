" denite.nvim config
call denite#custom#source('grep', 'max_candidates', 5000)
if executable('rg')
  call denite#custom#var('file/rec', 'command',
    \ ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg', '--threads', '4', '--no-messages'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--vimgrep', '--no-heading'])
else
  call denite#custom#var('file/rec', 'command',
    \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif

call denite#custom#source('tag', 'matchers', ['matcher/substring'])
call denite#custom#source('file/rec', 'matchers',
  \ ['matcher/fruzzy'])

call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
  \ ['git', 'ls-files', '-co', '--exclude-standard'])

call denite#custom#option('default', {
  \ 'highlight_filter_background': 'CursorLine',
  \ 'source_names': 'short',
  \ 'split': 'floating',
  \ })

call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

call denite#custom#map('insert', '<C-j>',
  \ '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>',
  \ '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', "'",
  \ '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('normal', 'r',
  \ '<denite:do_action:quickfix>', 'noremap')

let s:menus = {}
let s:menus.vim = {
  \ 'description': 'Vim',
  \ }
let s:menus.vim.file_candidates = [
  \ ['    > Edit configuation file (init.vim)', '~/.config/nvim/init.vim']
  \ ]
call denite#custom#var('menu', 'menus', s:menus)

call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
  \ [ '.git/', 'images/', '*.min.*', 'img/', 'fonts/',
  \ 'log/', 'tmp/', 'coverage/', 'node_modules/'])
