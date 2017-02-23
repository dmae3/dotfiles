" vim-quickrun config
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
